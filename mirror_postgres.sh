#!/bin/bash

# Must be set:
# REGISTRY_REDHAT_USER - user with access to registry.redhat.io
# REGISTRY_REDHAT_PASSWORD - password for user with access to registry.redhat.io
# RH_BREW_REGISTRY_USERNAME - user with access to brew.registry.redhat.io
# RH_BREW_REGISTRY_PASSWORD - password for user with access to registry.redhat.io
# QUAY_USER - user with access to push to quay.io/acm-d
# QUAY_PASSWORD - password for userr with access to push to quay.io/acm-d

# ---------------------------------------------------------------------------
# MEI Destination Variables
DEST_URL_KUBE_RBAC_PROXY_RHEL9=quay.io/acm-d/ose-kube-rbac-proxy-rhel9
DEST_URL_CAPI_RHEL9=quay.io/acm-d/ose-cluster-api-rhel9
DEST_URL_CAPA_RHEL9=quay.io/acm-d/ose-aws-cluster-api-controllers-rhel9
DEST_URL_CAPB_RHEL9=quay.io/acm-d/ose-baremetal-cluster-api-controllers-rhel9
DEST_URL_ORIGIN_CLI_RHEL9=quay.io/acm-d/origin-cli-rhel9
DEST_URL_POSTGRES_12=quay.io/acm-d/postgresql-12
DEST_URL_POSTGRES_13=quay.io/acm-d/postgresql-13
DEST_URL_POSTGRES_16=quay.io/acm-d/postgresql-16
DEST_URL_REDIS_7_C9S_RHEL9=quay.io/acm-d/redis-7-c9s-rhel9
DEST_URL_REDIS_7=quay.io/acm-d/redis-7
DEST_URL_VOLSYNC_RHEL9=quay.io/acm-d/volsync-rhel9
# ---------------------------------------------------------------------------
# MRI Variables

# Memcached
REG_MC_URI=rhel9/memcached
REG_MC_DEST=quay.io/acm-d/memcached

REG_MC_VERSION_A=9.6-1747641981
REG_MC_DIGEST_A1=sha256:b39f4ad63c694b76ac87ca168155cdcdff8d575d143ab941c2e068a68b30235c
REG_MC_DIGEST_A2=sha256:ff14f267f1e2f872c7e1ef75cd17ad20d26730c224f10bb243d7b5840f593fe7

REG_MC_VERSION_B=9.6-1749658726
REG_MC_DIGEST_B1=sha256:f7b505b1deeb9e97eece142468feef244c47c8c7ce3e41b2517b1acee4c735ad
REG_MC_DIGEST_B2=sha256:e493c0f389e21ab97a9c8bbd30c53e18227ecbb2cf84d201e8043722ae77bc79

# Flightctl-cli-artifacts
REG_FCA_URI=rhem/flightctl-cli-artifacts-rhel9
REG_FCA_DEST=quay.io/acm-d/flightctl-cli-artifacts-rhel9

REG_FCA_DIGEST=sha256:3aff03366b348976990d545eddafd86610d3491f799092848c47c722aa6bf6d9
REG_FCA_VERSION=0.7.1-1747322739

# ---------------------------------------------------------------------------
# Functions
mirror_external_images () {
    # DEBUG
    echo "======= MEI: Mirroring $3 to $4... ======="
    echo "--- Branch = $2 ---"
    # Clone
    git clone --branch=$2 --depth=1 https://pkgs.devel.redhat.com/git/containers/$1
    pushd $1/extras
    IMAGE_JSON=$(cat *.json | jq -r --arg version "$3" '.[] | select(.["image-key"] == $version)')
    SOURCE_URI=$(echo $IMAGE_JSON | jq -r '.["image-remote"]')/$(echo $IMAGE_JSON | jq -r '.["image-name"]')@$(echo $IMAGE_JSON | jq -r '.["image-digest"]')
    # Replace the source registry with an override if provided
    if [[ "$6" != "" ]]; then
        SOURCE_URI=$(echo $SOURCE_URI | sed -e "s/registry.redhat.io/$6/g")
    fi
    # DEBUG
    echo "--- Source URI = $SOURCE_URI ---"
    # Get a version tag if there is one to use as a tag
    IMAGE_REBUILD="$(skopeo inspect --authfile=$5 --no-tags docker://$SOURCE_URI | jq -r '.Labels["release"]')"
    IMAGE_VERSION="$(skopeo inspect --authfile=$5 --no-tags docker://$SOURCE_URI | jq -r '.Labels["version"]')"-$IMAGE_REBUILD
    # DEBUG
    echo "--- Image version = $IMAGE_VERSION ---"
    # Mirror with a version if present, omit if not
    if [[ "$IMAGE_VERSION" != "null" ]]; then
        echo "--- oc image mirror --registry-config=$5 --keep-manifest-list=true $SOURCE_URI $4:$IMAGE_VERSION ---"
        oc image mirror --registry-config=$5 --keep-manifest-list=true $SOURCE_URI $4:$IMAGE_VERSION
    else
        echo "--- oc image mirror --registry-config=$5 --keep-manifest-list=true $SOURCE_URI $4 ---"
        oc image mirror --registry-config=$5 --keep-manifest-list=true $SOURCE_URI $4
    fi
    popd
    rm -rf $1
    # DEBUG
    echo "======= MEI: End mirror: $3 ======="
}
# ---------------------------------------------------------------------------
mirror_registry_image () {
    echo "======= MRI: Mirroring $1 to $4... ======="

    SOURCE_URI="registry.redhat.io/$1@$2"
    IMAGE_VERSION="$3"
    DEST="$4"

    # DEBUG
    echo "--- Source URI = $SOURCE_URI ---"
    echo "--- Image version = $IMAGE_VERSION ---"
    echo "--- Destination = $DEST ---"
    echo "--- oc image mirror --registry-config=$5 --keep-manifest-list=true $SOURCE_URI $DEST:$IMAGE_VERSION ---"
    # Mirror
    oc image mirror --registry-config=$5 --keep-manifest-list=true $SOURCE_URI $DEST:$IMAGE_VERSION
    echo "======= MRI: End mirror: $1 ======="
}
# ---------------------------------------------------------------------------
# Configure Authfile without Podman
AUTHFILE=$PWD/auth.json
QUAY_AUTH="$(echo -n "$QUAY_USER:$QUAY_PASSWORD" | base64 -w 0)"
REDHAT_AUTH="$(echo -n "$REGISTRY_REDHAT_USER:$REGISTRY_REDHAT_PASSWORD" | base64 -w 0)"
BREW_AUTH="$(echo -n "$RH_BREW_REGISTRY_USERNAME:$RH_BREW_REGISTRY_PASSWORD" | base64 -w 0)"
jq --arg redhat_auth "$REDHAT_AUTH" --arg quay_auth "$QUAY_AUTH" --arg brew_auth $BREW_AUTH --null-input -r --tab \
    '{"auths":{"quay.io":{"auth":$quay_auth},"registry.redhat.io":{"auth":$redhat_auth}, "brew.registry.redhat.io":{"auth":$brew_auth}}}' > $AUTHFILE

# ---------------------------------------------------------------------------
echo "============== Running MEI mirror jobs =============="
# MCE
mirror_external_images multicluster-engine-operator-bundle multicluster-engine-2.4-rhel-8 postgresql_12 $DEST_URL_POSTGRES_12 $AUTHFILE
mirror_external_images multicluster-engine-operator-bundle multicluster-engine-2.5-rhel-9 postgresql_12 $DEST_URL_POSTGRES_12 $AUTHFILE
mirror_external_images multicluster-engine-operator-bundle multicluster-engine-2.6-rhel-9 postgresql_12 $DEST_URL_POSTGRES_12 $AUTHFILE
mirror_external_images multicluster-engine-operator-bundle multicluster-engine-2.7-rhel-9 postgresql_12 $DEST_URL_POSTGRES_12 $AUTHFILE
mirror_external_images multicluster-engine-operator-bundle multicluster-engine-2.8-rhel-9 postgresql_12 $DEST_URL_POSTGRES_12 $AUTHFILE
mirror_external_images multicluster-engine-operator-bundle multicluster-engine-2.9-rhel-9 postgresql_12 $DEST_URL_POSTGRES_12 $AUTHFILE

mirror_external_images multicluster-engine-operator-bundle multicluster-engine-2.8-rhel-9 ose_aws_cluster_api_controllers_rhel9 $DEST_URL_CAPA_RHEL9 $AUTHFILE brew.registry.redhat.io
mirror_external_images multicluster-engine-operator-bundle multicluster-engine-2.9-rhel-9 ose_aws_cluster_api_controllers_rhel9 $DEST_URL_CAPA_RHEL9 $AUTHFILE brew.registry.redhat.io

mirror_external_images multicluster-engine-operator-bundle multicluster-engine-2.8-rhel-9 ose_cluster_api_rhel9 $DEST_URL_CAPI_RHEL9 $AUTHFILE brew.registry.redhat.io
mirror_external_images multicluster-engine-operator-bundle multicluster-engine-2.9-rhel-9 ose_cluster_api_rhel9 $DEST_URL_CAPI_RHEL9 $AUTHFILE brew.registry.redhat.io

mirror_external_images multicluster-engine-operator-bundle multicluster-engine-2.9-rhel-9 ose_baremetal_cluster_api_controllers_rhel9 $DEST_URL_CAPB_RHEL9 $AUTHFILE brew.registry.redhat.io

# ACM
mirror_external_images acm-operator-bundle rhacm-2.9-rhel-8 postgresql_13 $DEST_URL_POSTGRES_13 $AUTHFILE
mirror_external_images acm-operator-bundle rhacm-2.10-rhel-9 postgresql_13 $DEST_URL_POSTGRES_13 $AUTHFILE
mirror_external_images acm-operator-bundle rhacm-2.11-rhel-9 postgresql_13 $DEST_URL_POSTGRES_13 $AUTHFILE
mirror_external_images acm-operator-bundle rhacm-2.12-rhel-9 postgresql_13 $DEST_URL_POSTGRES_13 $AUTHFILE
mirror_external_images acm-operator-bundle rhacm-2.13-rhel-9 postgresql_13 $DEST_URL_POSTGRES_13 $AUTHFILE
mirror_external_images acm-operator-bundle rhacm-2.14-rhel-9 postgresql_13 $DEST_URL_POSTGRES_13 $AUTHFILE

mirror_external_images acm-operator-bundle rhacm-2.13-rhel-9 postgresql_16 $DEST_URL_POSTGRES_16 $AUTHFILE
mirror_external_images acm-operator-bundle rhacm-2.14-rhel-9 postgresql_16 $DEST_URL_POSTGRES_16 $AUTHFILE

mirror_external_images acm-operator-bundle rhacm-2.13-rhel-9 ose_kube_rbac_proxy $DEST_URL_KUBE_RBAC_PROXY_RHEL9 $AUTHFILE brew.registry.redhat.io
mirror_external_images acm-operator-bundle rhacm-2.14-rhel-9 ose_kube_rbac_proxy $DEST_URL_KUBE_RBAC_PROXY_RHEL9 $AUTHFILE brew.registry.redhat.io

mirror_external_images acm-operator-bundle rhacm-2.13-rhel-9 volsync $DEST_URL_VOLSYNC_RHEL9 $AUTHFILE brew.registry.redhat.io
mirror_external_images acm-operator-bundle rhacm-2.14-rhel-9 volsync $DEST_URL_VOLSYNC_RHEL9 $AUTHFILE brew.registry.redhat.io

mirror_external_images acm-operator-bundle rhacm-2.13-rhel-9 origin_cli $DEST_URL_ORIGIN_CLI_RHEL9 $AUTHFILE brew.registry.redhat.io
mirror_external_images acm-operator-bundle rhacm-2.14-rhel-9 origin_cli $DEST_URL_ORIGIN_CLI_RHEL9 $AUTHFILE brew.registry.redhat.io

mirror_external_images acm-operator-bundle rhacm-2.13-rhel-9 redis $DEST_URL_REDIS_7 $AUTHFILE brew.registry.redhat.io
mirror_external_images acm-operator-bundle rhacm-2.14-rhel-9 redis_7_c9s $DEST_URL_REDIS_7_C9S_RHEL9 $AUTHFILE brew.registry.redhat.io
# ---------------------------------------------------------------------------
echo "============== Running MRI mirror jobs =============="
# memcached
#mirror_registry_image $REG_MC_URI $REG_MC_DIGEST $REG_MC_VERSION $REG_MC_DEST $AUTHFILE
mirror_registry_image $REG_MC_URI $REG_MC_DIGEST_A1 $REG_MC_VERSION_A $REG_MC_DEST $AUTHFILE
#mirror_registry_image $REG_MC_URI $REG_MC_DIGEST_A2 $REG_MC_VERSION_A $REG_MC_DEST $AUTHFILE

mirror_registry_image $REG_MC_URI $REG_MC_DIGEST_B1 $REG_MC_VERSION_B $REG_MC_DEST $AUTHFILE
#mirror_registry_image $REG_MC_URI $REG_MC_DIGEST_B2 $REG_MC_VERSION_B $REG_MC_DEST $AUTHFILE

# flightctl-cli-artifacts-rhel9 - DISABLING 
#mirror_registry_image $REG_FCA_URI $REG_FCA_DIGEST $REG_FCA_VERSION $REG_FCA_DEST $AUTHFILE
# ---------------------------------------------------------------------------
echo "============== End mirror jobs =============="
# Clean up authfile
rm -f $AUTHFILE
