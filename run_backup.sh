#!/bin/bash

BACKUP_PREFIX="/backups/$(date +%Y.%m.%d)/"

if [ "$#" -eq 0 ]; then
    echo "No backup profile specified, doing nothing"

    if [ ! -z "${BACKUP_PROFILE}" ]; then
        echo "Found BACKUP_PROFILE env"
    else
        if [ -z "$RC0_IF_NOT_ARGUMENT" ]; then
            exit 1
        else
            exit 0
        fi
    fi
else
    BACKUP_PROFILE="$1"
fi

echo "Doing backup profile ${BACKUP_PROFILE}"

mkdir -p "${BACKUP_PREFIX}"

function intertar {
    if [ "$RATE_LIMIT" == "none" ]; then
        nice -n "${TAR_NICE}" tar -czf "${BACKUP_PREFIX}$1.tar.gz" "$2"
    else
        nice -n "${TAR_NICE}" tar -czf - "$2" | pv -L "${RATE_LIMIT}" > "${BACKUP_PREFIX}$1.tar.gz"
    fi
}

function archive_tar {
    if [ "$RATE_LIMIT" == "none" ]; then
        nice -n "${TAR_NICE}" tar -cf "${BACKUP_PREFIX}$1.tar" "/root$2"
    else
        nice -n "${TAR_NICE}" tar -cf - "/root$2" | pv -L "${RATE_LIMIT}" > "${BACKUP_PREFIX}$1.tar"
    fi
}

function archive_gzip {
    gzip "${BACKUP_PREFIX}$1.tar"
}

function backup {
    intertar "$1" "/root/var/lib/docker/volumes/$1"
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


if [ ! -f "${PROFILE_DIRECTORY}/${BACKUP_PROFILE}" ]; then
    echo "Backup profile not found"
    exit 2
else
    source "${PROFILE_DIRECTORY}/${BACKUP_PROFILE}"
fi
