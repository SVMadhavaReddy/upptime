FROM ubuntu:20.04

# set the github runner version
ARG RUNNER_VERSION="2.302.1"

# update the base packages and add a non-sudo user
RUN apt-get update -y && apt-get upgrade -y && useradd -m github

WORKDIR /home/github/actions-runner

# install packages your code depends on
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    curl jq build-essential libssl-dev libffi-dev git npm

# download and unzip the github actions runner
RUN curl -O -L https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz \
    && tar xzf ./actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz

RUN chown -R github ~github && ./bin/installdependencies.sh

COPY start.sh start.sh

RUN chmod +x start.sh

USER github

CMD ["/start.sh"]
