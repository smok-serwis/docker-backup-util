#!/bin/bash

BACKUP_PREFIX="/backups/$(date +%Y%m%e)/"

if [ "$#" -eq 0 ]; then
    echo "No backup profile specified, doing nothing"

    if [ ! -z "$FAILURE_IS_SUCCESS" ]; then
        exit 0
    else
        exit 1
    fi
fi

echo "Doing backup profile $1"

mkdir -p "${BACKUP_PREFIX}"

function intertar {
    tar -czf "${BACKUP_PREFIX}$1.tar.gz" "$2"
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
    if [ ! -z "$FAILURE_IS_SUCCESS" ]; then
        exit 0
    else
        echo "Backup profile not found"
        exit 1
    fi
else
    source "${PROFILE_DIRECTORY}/$1"
fi
