#!/bin/bash

# Must be set:
# REGISTRY_REDHAT_USER - user with access to registry.redhat.io
# REGISTRY_REDHAT_PASSWORD - password for user with access to registry.redhat.io
# QUAY_USER - user with access to push to quay.io/acm-d
# QUAY_PASSWORD - password for userr with access to push to quay.io/acm-d

# Global Vars
DEST_URL_POSTGRES_12=quay.io/acm-d/postgresql-12
DEST_URL_POSTGRES_13=quay.io/acm-d/postgresql-13

# Functions
mirror_postgres () {
    git clone --branch=$2 --depth=1 https://pkgs.devel.redhat.com/git/containers/$1
    pushd $1/extras
    IMAGE_JSON=$(cat *.json | jq -r --arg version "$3" '.[] | select(.["image-key"] == $version)')
    SOURCE_URL=$(echo $IMAGE_JSON | jq -r '.["image-remote"]')/$(echo $IMAGE_JSON | jq -r '.["image-name"]')@$(echo $IMAGE_JSON | jq -r '.["image-digest"]')
    echo "oc image mirror --registry-config=$5 --keep-manifest-list=true $SOURCE_URL $4"
    oc image mirror --registry-config=$5 --keep-manifest-list=true $SOURCE_URL $4
    popd
    rm -rf $1
}

# Configure Authfile without Podman
AUTHFILE=$PWD/auth.json
QUAY_AUTH="$(echo -n "$QUAY_USER:$QUAY_PASSWORD" | base64 -w 0)"
REDHAT_AUTH="$(echo -n "$REGISTRY_REDHAT_USER:$REGISTRY_REDHAT_PASSWORD" | base64 -w 0)"
jq --arg redhat_auth "$REDHAT_AUTH" --arg quay_auth "$QUAY_AUTH" --null-input -r --tab \
    '{"auths":{"quay.io":{"auth":$quay_auth},"registry.redhat.io":{"auth":$redhat_auth}}}' > $AUTHFILE

# MCE
mirror_postgres multicluster-engine-operator-bundle multicluster-engine-2.2-rhel-8 postgresql_12 $DEST_URL_POSTGRES_12 $AUTHFILE
mirror_postgres multicluster-engine-operator-bundle multicluster-engine-2.3-rhel-8 postgresql_12 $DEST_URL_POSTGRES_12 $AUTHFILE
mirror_postgres multicluster-engine-operator-bundle multicluster-engine-2.4-rhel-8 postgresql_12 $DEST_URL_POSTGRES_12 $AUTHFILE
mirror_postgres multicluster-engine-operator-bundle multicluster-engine-2.5-rhel-9 postgresql_12 $DEST_URL_POSTGRES_12 $AUTHFILE
mirror_postgres multicluster-engine-operator-bundle multicluster-engine-2.6-rhel-9 postgresql_12 $DEST_URL_POSTGRES_12 $AUTHFILE
mirror_postgres multicluster-engine-operator-bundle multicluster-engine-2.7-rhel-9 postgresql_12 $DEST_URL_POSTGRES_12 $AUTHFILE
mirror_postgres multicluster-engine-operator-bundle multicluster-engine-2.8-rhel-9 postgresql_12 $DEST_URL_POSTGRES_12 $AUTHFILE

# ACM
mirror_postgres acm-operator-bundle rhacm-2.7-rhel-8 postgresql_13 $DEST_URL_POSTGRES_13 $AUTHFILE
mirror_postgres acm-operator-bundle rhacm-2.8-rhel-8 postgresql_13 $DEST_URL_POSTGRES_13 $AUTHFILE
mirror_postgres acm-operator-bundle rhacm-2.9-rhel-8 postgresql_13 $DEST_URL_POSTGRES_13 $AUTHFILE
mirror_postgres acm-operator-bundle rhacm-2.10-rhel-9 postgresql_13 $DEST_URL_POSTGRES_13 $AUTHFILE
mirror_postgres acm-operator-bundle rhacm-2.11-rhel-9 postgresql_13 $DEST_URL_POSTGRES_13 $AUTHFILE
mirror_postgres acm-operator-bundle rhacm-2.12-rhel-9 postgresql_13 $DEST_URL_POSTGRES_13 $AUTHFILE
mirror_postgres acm-operator-bundle rhacm-2.13-rhel-9 postgresql_13 $DEST_URL_POSTGRES_13 $AUTHFILE

# Clean up authfile
rm -f $AUTHFILE
