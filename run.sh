#!/usr/bin/env bash

NAME="interbase"
PORT="3050"
VERSION="latest"
DETACH=false

while [ $# -gt 0 ]; do
    case "$1" in
        --name|-n)
            if [[ "$1" != *=* ]]; then shift; fi
            NAME="${1#*=}"
            ;;
        --port|-p)
            if [[ "$1" != *=* ]]; then shift; fi
            PORT="${1#*=}"
            ;;
        --version|-v)
            if [[ "$1" != *=* ]]; then shift; fi
            VERSION="${1#*=}"
            ;;
        --detach|-d)
            DETACH=true
            ;;
        --help|-h)
            printf "Usage: run.sh [OPTIONS]\n\n"
            printf "Example 1: run.sh --detach --name my_database --port 3050 --version latest\n\n"
            printf "Example 1: run.sh -d -n my_database -p 3050 -v latest\n\n"
            printf "Options:\n"
            printf "  --name, -n NAME\tSpecify the name of the container - default: ${NAME}\n"
            printf "  --port, -p PORT\tSpecify the port to be used by InterBase - default: ${PORT}\n"
            printf "  --version, -v VERSION\tSpecify the InterBase tag to be used as image - default: ${VERSION}\n"
            printf "  --detach, -d\t\tRun in detached mode - default: ${DETACH}\n"
            printf "  --help, -h\t\tDisplay this help and exit\n"
            exit 0
            ;;
        *)
            >&2 printf "Error: Invalid argument\n"
            exit 1
            ;;
    esac
    shift
done

if [ "$DETACH" = true ]; then
    DETACH_ARG="-d"
else
    DETACH_ARG="-it"
fi

docker run $DETACH_ARG \
    -p $PORT:3050 \
    --rm \
    --name $NAME \
    --mount type=volume,source=interbase,target=/opt/interbase \
    --mount type=volume,source=iblicense,target=/opt/interbase/license \
    --mount type=volume,source=ibdata,target=/interbase \
    radstudio/interbase:$VERSION
