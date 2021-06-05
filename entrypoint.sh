#!/bin/bash

set -o errexit -o pipefail -o nounset

GITHUB_REPO=${INPUT_GITHUB_REPO}
UPLOAD_REPO=${INPUT_UPLOAD_REPO:-}
TWINE_USERNAME=${INPUT_TWINE_USERNAME}
TWINE_PASSWORD=${INPUT_TWINE_PASSWORD}
VERIFY_METADATA=${INPUT_VERIFY_METADATA}
SKIP_EXISTING=${INPUT_SKIP_EXISTING}
VERBOSE=${INPUT_VERBOSE}

REPO_NAME=$(cut -d "/" -f2 <<< ${GITHUB_REPO})

echo "---------------- CLONE REPO ----------------"

git clone https://github.com/${GITHUB_REPO}

cd ${REPO_NAME}

echo "---------------- MODIFY SETUP FILE ----------------"

RELEASE_VER=`curl -s https://api.github.com/repos/${GITHUB_REPO}/releases | jq -r .[0].tag_name`

if [[ ${RELEASE_VER} == v* ]];
then
        CLEAN_VER=$(echo ${RELEASE_VER} | sed '0,/v/ s/v//')
else
        CLEAN_VER=${RELEASE_VER}
fi

echo "Cleaned version name: ${CLEAN_VER}"

VERSION_REGEX='version=\"[^"]\+\"'
VERSION_REPLACE="version=\"${CLEAN_VER}\""

sed -i -e "s/${VERSION_REGEX}/${VERSION_REPLACE}/g" setup.py

echo "---------------- BUILD PACKAGE ----------------"

python setup.py sdist bdist_wheel

if [[ ${VERIFY_METADATA} != "false" ]] ; then
    twine check dist/*
fi

echo "---------------- PUBLISH PACKAGE ----------------"

EXTRA_ARGS=

if [[ -n "${UPLOAD_REPO}" ]]; then
    EXTRA_ARGS="--repository-url ${UPLOAD_REPO} ${EXTRA_ARGS}"
    echo "-------- Using repository: ${UPLOAD_REPO}"
fi

if [[ ${SKIP_EXISTING} != "false" ]] ; then
    EXTRA_ARGS="--skip-existing ${EXTRA_ARGS}"
fi

if [[ ${VERBOSE} != "false" ]] ; then
    EXTRA_ARGS="--verbose ${EXTRA_ARGS}"
fi

python -m twine upload dist/* -u ${TWINE_USERNAME} -p ${TWINE_PASSWORD} ${EXTRA_ARGS}
