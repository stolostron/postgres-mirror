#!/bin/bash

# Must be set:
# REGISTRY_REDHAT_USER - user with access to registry.redhat.io
# REGISTRY_REDHAT_PASSWORD - password for user with access to registry.redhat.io
# RH_BREW_REGISTRY_USERNAME - user with access to brew.registry.redhat.io
# RH_BREW_REGISTRY_PASSWORD - password for user with access to registry.redhat.io
# QUAY_USER - user with access to push to quay.io/acm-d
# QUAY_PASSWORD - password for userr with access to push to quay.io/acm-d

# Global Vars
DEST_URL_KUBE_RBAC_PROXY_RHEL9=quay.io/acm-d/ose-kube-rbac-proxy-rhel9
DEST_URL_CAPI_RHEL9=quay.io/acm-d/ose-cluster-api-rhel9
DEST_URL_CAPA_RHEL9=quay.io/acm-d/ose-aws-cluster-api-controllers-rhel9
DEST_URL_POSTGRES_12=quay.io/acm-d/postgresql-12
DEST_URL_POSTGRES_13=quay.io/acm-d/postgresql-13
DEST_URL_POSTGRES_16=quay.io/acm-d/postgresql-16
DEST_URL_VOLSYNC_RHEL9=quay.io/acm-d/volsync-rhel9

# Functions
mirror_external_images () {
    git clone --branch=$2 --depth=1 https://pkgs.devel.redhat.com/git/containers/$1
    pushd $1/extras
    IMAGE_JSON=$(cat *.json | jq -r --arg version "$3" '.[] | select(.["image-key"] == $version)')
    SOURCE_URL=$(echo $IMAGE_JSON | jq -r '.["image-remote"]')/$(echo $IMAGE_JSON | jq -r '.["image-name"]')@$(echo $IMAGE_JSON | jq -r '.["image-digest"]')
    # Replace the source registry with an override if provided
    if [[ "$6" != "" ]]; then
        SOURCE_URL=$(echo $SOURCE_URL | sed -e "s/registry.redhat.io/$6/g")
    fi
    # Get a version tag if there is one to use as a tag
    IMAGE_VERSION="$(skopeo inspect --authfile=$5 --no-tags docker://$SOURCE_URL | jq -r '.Labels["version"]')"
    # Mirror with a version if present, omit if not
    if [[ "$IMAGE_VERSION" != "null" ]]; then
        echo "oc image mirror --registry-config=$5 --keep-manifest-list=true $SOURCE_URL $4:$IMAGE_VERSION"
        oc image mirror --registry-config=$5 --keep-manifest-list=true $SOURCE_URL $4:$IMAGE_VERSION
    else
        echo "oc image mirror --registry-config=$5 --keep-manifest-list=true $SOURCE_URL $4"
        oc image mirror --registry-config=$5 --keep-manifest-list=true $SOURCE_URL $4
    fi
    popd
    rm -rf $1
}

# Configure Authfile without Podman
AUTHFILE=$PWD/auth.json
QUAY_AUTH="$(echo -n "$QUAY_USER:$QUAY_PASSWORD" | base64 -w 0)"
REDHAT_AUTH="$(echo -n "$REGISTRY_REDHAT_USER:$REGISTRY_REDHAT_PASSWORD" | base64 -w 0)"
BREW_AUTH="$(echo -n "$RH_BREW_REGISTRY_USERNAME:$RH_BREW_REGISTRY_PASSWORD" | base64 -w 0)"
jq --arg redhat_auth "$REDHAT_AUTH" --arg quay_auth "$QUAY_AUTH" --arg brew_auth $BREW_AUTH --null-input -r --tab \
    '{"auths":{"quay.io":{"auth":$quay_auth},"registry.redhat.io":{"auth":$redhat_auth}, "brew.registry.redhat.io":{"auth":$brew_auth}}}' > $AUTHFILE

# MCE
mirror_external_images multicluster-engine-operator-bundle multicluster-engine-2.4-rhel-8 postgresql_12 $DEST_URL_POSTGRES_12 $AUTHFILE
mirror_external_images multicluster-engine-operator-bundle multicluster-engine-2.5-rhel-9 postgresql_12 $DEST_URL_POSTGRES_12 $AUTHFILE
mirror_external_images multicluster-engine-operator-bundle multicluster-engine-2.6-rhel-9 postgresql_12 $DEST_URL_POSTGRES_12 $AUTHFILE
mirror_external_images multicluster-engine-operator-bundle multicluster-engine-2.7-rhel-9 postgresql_12 $DEST_URL_POSTGRES_12 $AUTHFILE
mirror_external_images multicluster-engine-operator-bundle multicluster-engine-2.8-rhel-9 postgresql_12 $DEST_URL_POSTGRES_12 $AUTHFILE

mirror_external_images multicluster-engine-operator-bundle multicluster-engine-2.8-rhel-9 ose_cluster_api_rhel9 $DEST_URL_CAPI_RHEL9 $AUTHFILE brew.registry.redhat.io
mirror_external_images multicluster-engine-operator-bundle multicluster-engine-2.8-rhel-9 ose_aws_cluster_api_controllers_rhel9 $DEST_URL_CAPA_RHEL9 $AUTHFILE brew.registry.redhat.io

# ACM
mirror_external_images acm-operator-bundle rhacm-2.9-rhel-8 postgresql_13 $DEST_URL_POSTGRES_13 $AUTHFILE
mirror_external_images acm-operator-bundle rhacm-2.10-rhel-9 postgresql_13 $DEST_URL_POSTGRES_13 $AUTHFILE
mirror_external_images acm-operator-bundle rhacm-2.11-rhel-9 postgresql_13 $DEST_URL_POSTGRES_13 $AUTHFILE
mirror_external_images acm-operator-bundle rhacm-2.12-rhel-9 postgresql_13 $DEST_URL_POSTGRES_13 $AUTHFILE
mirror_external_images acm-operator-bundle rhacm-2.13-rhel-9 postgresql_13 $DEST_URL_POSTGRES_13 $AUTHFILE

mirror_external_images acm-operator-bundle rhacm-2.13-rhel-9 postgresql_16 $DEST_URL_POSTGRES_16 $AUTHFILE

mirror_external_images acm-operator-bundle rhacm-2.13-rhel-9 ose_kube_rbac_proxy $DEST_URL_KUBE_RBAC_PROXY_RHEL9 $AUTHFILE
mirror_external_images acm-operator-bundle rhacm-2.13-rhel-9 volsync $DEST_URL_VOLSYNC_RHEL9 $AUTHFILE

# Clean up authfile
rm -f $AUTHFILE
