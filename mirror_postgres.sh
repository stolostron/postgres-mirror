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
    oc image mirror --keep-manifest-list=true $SOURCE_URL $4
    popd
    rm -rf $1
}

# Login
skopeo login registry.redhat.io -u $REGISTRY_REDHAT_USER -p "$REGISTRY_REDHAT_PASSWORD"
skopeo login quay.io -u $QUAY_USER -p $QUAY_PASSWORD

# MCE
mirror_postgres multicluster-engine-operator-bundle multicluster-engine-2.2-rhel-8 postgresql_12 $DEST_URL_POSTGRES_12
mirror_postgres multicluster-engine-operator-bundle multicluster-engine-2.3-rhel-8 postgresql_12 $DEST_URL_POSTGRES_12
mirror_postgres multicluster-engine-operator-bundle multicluster-engine-2.4-rhel-8 postgresql_12 $DEST_URL_POSTGRES_12
mirror_postgres multicluster-engine-operator-bundle multicluster-engine-2.5-rhel-9 postgresql_12 $DEST_URL_POSTGRES_12
mirror_postgres multicluster-engine-operator-bundle multicluster-engine-2.6-rhel-9 postgresql_12 $DEST_URL_POSTGRES_12

# ACM
mirror_postgres acm-operator-bundle rhacm-2.7-rhel-8 postgresql_13 $DEST_URL_POSTGRES_13
mirror_postgres acm-operator-bundle rhacm-2.8-rhel-8 postgresql_13 $DEST_URL_POSTGRES_13
mirror_postgres acm-operator-bundle rhacm-2.9-rhel-8 postgresql_13 $DEST_URL_POSTGRES_13
mirror_postgres acm-operator-bundle rhacm-2.10-rhel-9 postgresql_13 $DEST_URL_POSTGRES_13
mirror_postgres acm-operator-bundle rhacm-2.11-rhel-9 postgresql_13 $DEST_URL_POSTGRES_13
