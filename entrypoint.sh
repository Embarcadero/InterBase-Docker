#!/usr/bin/env bash
set -e

PATH="${PATH}:${PREFIX}/bin" 

readVar() {
    local var="$1"
    local fileVar="${var}_FILE"
    local def="${2:-}"
    
    if [ "${!var:-}" ] && [ "${!fileVar:-}" ]; then
        echo >&2 "error: both $var and $fileVar are set (but are exclusive)"
        exit 1
    fi

    local val="$def"

    if [ "${!var:-}" ]; then
        val="${!var:-}"
    elif [ "${!fileVar:-}" ]; then
        val="$(< "${!fileVar:-}" )"
    fi

    export "$var"="$val"
    unset "$fileVar"
}

sysdbaUpdate() {
    readVar 'IB_SYSDBA_OLD_PASSWORD'
    readVar 'IB_SYSDBA_NEW_PASSWORD'

    if [ -n "${IB_SYSDBA_OLD_PASSWORD}" ] && [ -n "${IB_SYSDBA_NEW_PASSWORD}" ]; then
        echo "Changing SYSDBA password..."
	
	    # gsec doesn't change errorcode on error, so unable to shut on command fail...
        "${PREFIX}"/bin/gsec -user SYSDBA -password "${IB_SYSDBA_OLD_PASSWORD}" \
                             -modify SYSDBA -pw ${IB_SYSDBA_NEW_PASSWORD}       
    fi 
}

createUser() {
    readVar 'IB_USER'
    readVar 'IB_PASSWORD'
    readVar 'IB_SYSDBA_PASSWORD'

    if [ -n "${IB_USER}" ] && [ -n "${IB_PASSWORD}" ] && [ -n "${IB_SYSDBA_PASSWORD}" ]; then
	    
        userList=$("${PREFIX}"/bin/gsec -user SYSDBA -password "$IB_SYSDBA_PASSWORD" -display 2>&1)
	    userName=$(echo "$IB_USER" | tr '[:lower:]' '[:upper:]')
	   
	    if ! echo "$userList" | grep -w "$userName" > /dev/null; then
	        echo "Creating user '${IB_USER}'..."

	        # gsec doesn't change errorcode on error, so unable to shut on command fail...
	        "${PREFIX}"/bin/gsec -user SYSDBA -password ${IB_SYSDBA_PASSWORD} \
			                 -add ${IB_USER} -pw ${IB_PASSWORD}  
	    fi
    fi
}

createDataBase() {
    mkdir -p "${DBPATH}"

    readVar 'IB_DATABASE'

    if [ -n "${IB_DATABASE}" ]; then        
        # Create only if not exists
        if [ ! -f "${DBPATH}/${IB_DATABASE}" ]; then
            echo "Creating database '${DBPATH}/${IB_DATABASE}'..."

            readVar 'IB_DATABASE_PAGE_SIZE'
            readVar 'IB_DATABASE_DEFAULT_CHARSET'

            local user_and_password=''
            [ -n "${IB_USER}" ] && user_and_password=" USER '${IB_USER}' PASSWORD '${IB_PASSWORD}'"

            local page_size=''
            [ -n "${IB_DATABASE_PAGE_SIZE}" ] && page_size="PAGE_SIZE ${IB_DATABASE_PAGE_SIZE}"

            local default_charset=''
            [ -n "${IB_DATABASE_DEFAULT_CHARSET}" ] && default_charset="DEFAULT CHARACTER SET ${IB_DATABASE_DEFAULT_CHARSET}"

            "${PREFIX}"/bin/isql <<-EOL > /dev/null 2>&1
CREATE DATABASE "${DBPATH}/${IB_DATABASE}" $user_and_password $page_size $default_charset;
COMMIT;
EXIT;
EOL
        fi
    fi
}

restoreBackups() {

    readVar 'RESTORE_USER'
    readVar 'RESTORE_PASSWORD'

    if [ -n "${RESTORE_USER}" ] && [ -n "${RESTORE_PASSWORD}" ]; then
        (
        shopt -s nullglob
        set +e

        for ibk in ${BKPPATH}/*.ibk; do
            basename="$(basename -- $ibk)"
            fname="${basename%.*}"
            (
            if [ ! -f "${DBPATH}/${fname}.ib" ]; then

                if [ -f "${BKPPATH}/${fname}.env" ]; then
                    . "${BKPPATH}/${fname}.env"
                fi

                echo -n "Restoring '$ibk' "
                "${PREFIX}/bin/gbak" -c -user "${RESTORE_USER}" -password "${RESTORE_PASSWORD}" "$ibk" "${DBPATH}/${fname}.ib"
                echo "to '${DBPATH}/${fname}.ib'"
            fi
            )
        done

        set -e
        )
    fi
}

interbaseSetup() {   
    sysdbaUpdate
    createUser
    createDataBase
    restoreBackups
}

sigintHandler() {
    echo "Stopping InterBase... [SIGINT received]" 
}

sigtermHandler() {   
    echo "Stopping InterBase... [SIGTERM received]" 
}

startServer() {   
    echo "Starting up..."

    trap sigintHandler SIGINT    
    trap sigtermHandler SIGTERM
    
    "${PREFIX}"/bin/ibguard -f -P gds_db & pid=$!
    sleep 5
}

waitFor() {   
    echo "Running..."
    wait $pid
}

if [[ "$1" == "interbase" ]]; then

    if ls -a "${LICENSEPATH}"/.[[:digit:]]*.slip 1> /dev/null 2>&1; then
        # Run InterBase
        IB_PROTOCOL=gds_db
        export IB_PROTOCOL
        INTERBASE="${PREFIX}"
        export INTERBASE

        startServer
        interbaseSetup
        waitFor
    else
        # Run registration
        /opt/interbase/bin/LicenseManagerLauncher -i Console
        exit $?
    fi    
fi

exec "$@"
