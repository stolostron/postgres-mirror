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
    git checkout $1
    pushd extras
    IMAGE_JSON=$(cat *.json | jq -r --arg version "$2" '.[] | select(.["image-key"] == $version)')
    SOURCE_URL=$(echo $IMAGE_JSON | jq -r '.["image-remote"]')/$(echo $IMAGE_JSON | jq -r '.["image-name"]')@$(echo $IMAGE_JSON | jq -r '.["image-digest"]')
    oc image mirror --keep-manifest-list=true $SOURCE_URL $3
    popd
}

# Login
podman login registry.redhat.io -u $REGISTRY_REDHAT_USER -p "$REGISTRY_REDHAT_PASSWORD"
podman login quay.io -u $QUAY_USER -p $QUAY_PASSWORD

# Get multicluster-engine-operator-bundle repo
git clone https://pkgs.devel.redhat.com/git/containers/multicluster-engine-operator-bundle
pushd multicluster-engine-operator-bundle
# MCE
mirror_postgres multicluster-engine-2.2-rhel-8 postgresql_12 $DEST_URL_POSTGRES_12
mirror_postgres multicluster-engine-2.3-rhel-8 postgresql_12 $DEST_URL_POSTGRES_12
mirror_postgres multicluster-engine-2.4-rhel-8 postgresql_12 $DEST_URL_POSTGRES_12
mirror_postgres multicluster-engine-2.5-rhel-9 postgresql_12 $DEST_URL_POSTGRES_12
mirror_postgres multicluster-engine-2.6-rhel-9 postgresql_12 $DEST_URL_POSTGRES_12
# Clean up multicluster-engine-operator-bundle
popd
rm -rf multicluster-engine-operator-bundle

# Get acm-operator-bundle repo
git clone https://pkgs.devel.redhat.com/git/containers/acm-operator-bundle
pushd acm-operator-bundle
# MCE
mirror_postgres rhacm-2.7-rhel-8 postgresql_13 $DEST_URL_POSTGRES_13
mirror_postgres rhacm-2.8-rhel-8 postgresql_13 $DEST_URL_POSTGRES_13
mirror_postgres rhacm-2.9-rhel-8 postgresql_13 $DEST_URL_POSTGRES_13
mirror_postgres rhacm-2.10-rhel-9 postgresql_13 $DEST_URL_POSTGRES_13
mirror_postgres rhacm-2.11-rhel-9 postgresql_13 $DEST_URL_POSTGRES_13
# Clean up multicluster-engine-operator-bundle
popd
rm -rf acm-operator-bundle
