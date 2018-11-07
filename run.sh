#!/usr/bin/env bash

BASE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

. ${BASE_DIR}/.env

function main () {
    for FILE_PATH in ${BASE_DIR}/repositories/*; do
        FILE_NAME=$(basename ${FILE_PATH})
        if [[ ${FILE_NAME: -5} == ".json" ]]
        then
            SCRIPT_NAME=$(echo ${FILE_NAME} | cut -d '.' -f1)
            if [[ $( check_script ${SCRIPT_NAME} ) == "1" ]]
            then
                echo "Overwriting script ${SCRIPT_NAME}"
                if [[ $( upload_script ${SCRIPT_NAME} ${FILE_PATH} "PUT" ) == "204" ]]
                then
                    echo "Success"
                else
                    echo "Unexpected status code, please check ${SCRIPT_NAME} repositories manually"
                fi
            else
                echo "Uploading script ${SCRIPT_NAME}"
                if [[ $( upload_script "" ${FILE_PATH} "POST" ) == "204" ]]
                then
                    echo "Success"
                else
                    echo "Unexpected status code, please check ${SCRIPT_NAME} repositories manually"
                fi
            fi

            echo "Executing remote script ${SCRIPT_NAME}"
            curl -s -X "POST" -u ${NEXUS_USR}:${NEXUS_PWD} --header "Content-Type: text/plain"  -w "\n%{http_code}\n" "${NEXUS_URL}/script/${SCRIPT_NAME}/run"
        else
            echo "Skipping non-json file ${FILE_NAME}"
        fi
    done
}

#curl -u ${NEXUS_USR}:${NEXUS_PWD} --header "Content-Type: application/json" "${NEXUS_URL}/script/" -d @${BASE_DIR}/repositories/npm.json

#curl -X POST -u ${NEXUS_USR}:${NEXUS_PWD} --header "Content-Type: text/plain" "${NEXUS_URL}script/npm/run"

function check_script () {
    local STATUS=$( curl -s -o /dev/null -u ${NEXUS_USR}:${NEXUS_PWD} -w "%{http_code}" -X GET "${NEXUS_URL}/script/${1}" )
    [[ ${STATUS} != 200 ]]; echo $?
    return
}

function upload_script () {
    curl -s -X ${3} -u ${NEXUS_USR}:${NEXUS_PWD} -w "%{http_code}"  --header "Content-Type: application/json" "${NEXUS_URL}/script/${1}" -d @${2}
    return
}


main