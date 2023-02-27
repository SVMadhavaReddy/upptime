#!/bin/bash

GH_USERNAME=${GH_USERNAME:-SVMadhavaReddy}
GH_REPO=${GH_REPO:-upptime}

REG_TOKEN=$(curl -sX POST -H "Authorization: Bearer ${GH_PAT}" "https://api.github.com/repos/${GH_USERNAME}/${GH_REPO}/actions/runners/registration-token" | jq .token --raw-output)

./config.sh --url "https://github.com/${GH_USERNAME}/${GH_REPO}" --token "${REG_TOKEN}" --name "spot-runner-$(hostname)" --unattended

cleanup() {
    echo "Removing runner..."
    ./config.sh remove --unattended --token "${REG_TOKEN}"
}

trap 'cleanup; exit 130' INT
trap 'cleanup; exit 143' TERM

./run.sh & wait $!
