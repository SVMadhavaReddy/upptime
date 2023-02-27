FROM ubuntu:20.04

ARG RUNNER_VERSION="2.302.1"
ENV DEBIAN_FRONTEND="noninteractive"

RUN apt-get update -y && apt-get upgrade -y && useradd -m github

RUN apt-get install -y software-properties-common build-essential libssl-dev libffi-dev

RUN add-apt-repository ppa:git-core/ppa -y && apt-get update -y

RUN apt-get install -y --no-install-recommends curl jq git npm

WORKDIR /actions-runner

# download and unzip the github actions runner
RUN curl -o /tmp/actions-runner.tar.gz -L https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz \
    && tar xzf /tmp/actions-runner.tar.gz

RUN chown -R github /actions-runner && ./bin/installdependencies.sh

COPY start.sh start.sh

RUN chmod +x start.sh

USER github

CMD ["./start.sh"]
