#!/bin/bash

BACKUP_PREFIX="/backups/$(date +%Y.%m.%d)/"

if [ "$#" -eq 0 ]; then
    echo "No backup profile specified, doing nothing"

    if [ -z "$RC0_IF_NOT_ARGUMENT" ]; then
        exit 1
    else
        exit 0
    fi
fi

echo "Doing backup profile $1"

mkdir -p "${BACKUP_PREFIX}"

function intertar {
    if [ "$RATE_LIMIT" == "none" ]; then
        nice -n "${TAR_NICE}" tar -czf - "$2" | pv -L "${RATE_LIMIT}" > "${BACKUP_PREFIX}$1.tar.gz"
    else
        nice -n "${TAR_NICE}" tar -czf - "$2" | pv -L "${RATE_LIMIT}" > "${BACKUP_PREFIX}$1.tar.gz"
    fi
}
function backup {
    intertar "$1" "/volumes/$1"
}

function archive {
    intertar "$2" "/root$1"
}

function stop {
    docker container stop $1
}

function start {
    docker container start $1
}


if [ ! -f "${PROFILE_DIRECTORY}/$1" ]; then
    echo "Backup profile not found"
    exit 2
else
    source "${PROFILE_DIRECTORY}/$1"
fi
