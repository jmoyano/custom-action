#!/bin/bash
echo "Start release creation"

# Check if this is a GitHub environment checking if the variable
# $GITHUB_EVENT_PATH exists
if [ -n "$GITHUB_EVENT_PATH" ];
then
    EVENT_PATH=$GITHUB_EVENT_PATH
    echo "It is a valid GitHub Event"
elif [ -f ./dummy_push.json ];
then
    EVENT_PATH="./dummy_push.json"
    LOCAL_TEST=true
    echo "It is a local test"
else 
    echo "No event JSON data"
    exit 1
fi

# jq . < $EVENT_PATH

RELEASE_TAG=$(bash -c \
    "jq '.commits[].message, .head_commit.message' < $EVENT_PATH \
    | grep -ioe 'RELEASE v[a-zA-Z0-9.]*'")

echo "Release tag: $RELEASE_TAG"

if [[ $RELEASE_TAG != "" ]];
then
    # Recover version tag
    VERSION=$(echo $RELEASE_TAG | grep -ioe "v.*")

    echo "Tag will be $VERSION"

    DATA="$(printf '{"tag_name":"%s",' $VERSION)"
    DATA="${DATA} $(printf '"target_commitish":"master",')"
    DATA="${DATA} $(printf '"name":"%s",' $VERSION)"
    DATA="${DATA} $(printf '"body":"Automated release based on keyword: %s",' "$*")"
    DATA="${DATA} $(printf '"draft":false, "prerelease":false}')"

    URL="https://api.github.com/repos/${GITHUB_REPOSITORY}/releases?access_token=${GITHUB_TOKEN}"

    if [[ "${LOCAL_TEST}" == *"true"* ]];
    then
        echo "[TEST] Version tag found, but running in local mode"
        echo $DATA
    else
        echo "Creating release $VERSION"
        echo $DATA | http POST $URL | jq .
    fi
# otherwise
else
    # exit gracefully
    echo "No release tag found"
fi

echo "Release creation finished"
