#!/usr/bin/env bash

ISQL="${PREFIX}"/bin/isql
HOST=localhost
PORT=3050

# Actual healthcheck only runs on registered InterBase
if ls -a "${LICENSEPATH}"/.[[:digit:]]*.slip 1> /dev/null 2>&1; then
    if [[ -z "${HC_USER}" || -z "${HC_PASSWORD}" || -z "${HC_DATABASE}" ]]; then
        # Only check if a connection can be established as user hasn't provided auth data
	echo > /dev/tcp/"${HOST}"/"${PORT}" 2>/dev/null
	exit $?
    else
	IB_RESULT=$(${ISQL} -m -user "${HC_USER}" -password "${HC_PASSWORD}" "${HOST}/${PORT}:${DBPATH}/${HC_DATABASE}" << "EOF"
	SHOW DATABASE;
EOF
	2>&1)
	EXIT_CODE=$?
	
	echo "$IB_RESULT" >&2
	
	IB_RESULT=$(echo "$IB_RESULT" | tr '[:upper:]' '[:lower:]')
		
	if [[ $exit_code -ne 0 ]] || [[ "$IB_RESULT" == *"error"* ]]; then
	    exit 1
	fi
    fi
fi
