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

# openshift4/ose-cli-rhel9
REG_OCR_URI=openshift4/ose-cli-rhel9
REG_OCR_DEST=quay.io/acm-d/ose-cli-rhel9
REG_OCR_VERSION=v4.19.0-202506161807.p0.gfa1fd95.assembly.stream.el9
REG_OCR_DIGEST=2bc7ba0ff29191952dbd7bff883b378c868b3728f4cd1b491e23ef4c593e0bde

# rhel9/redis-7
REG_R7_URI=rhel9/redis-7
REG_R7_DEST=quay.io/acm-d/redis-7
REG_R7_VERSION=9.6-1749629182
REG_R7_DIGEST=a3bb7c5987829cf7d886d9418ac24f55783de71a6cbbbcde0fa17e609bb58a2e

# Memcached
REG_MC_URI=rhel9/memcached
REG_MC_DEST=quay.io/acm-d/memcached

REG_MC_VERSION_A=9.6-1747641981
REG_MC_DIGEST_A1=sha256:b39f4ad63c694b76ac87ca168155cdcdff8d575d143ab941c2e068a68b30235c
REG_MC_DIGEST_A2=sha256:ff14f267f1e2f872c7e1ef75cd17ad20d26730c224f10bb243d7b5840f593fe7

REG_MC_VERSION_B=9.6-1749658726
REG_MC_DIGEST_B1=sha256:f7b505b1deeb9e97eece142468feef244c47c8c7ce3e41b2517b1acee4c735ad
REG_MC_DIGEST_B2=sha256:e493c0f389e21ab97a9c8bbd30c53e18227ecbb2cf84d201e8043722ae77bc79

# Flightctl - all images
REG_FC_VERSION=v0.7.2

# Flight Control API Server
REG_FA_URI=rhem/flightctl-api-rhel9
REG_FA_DEST=quay.io/acm-d/flightctl-api-rhel9
REG_FA_DIGEST=sha256:83c6c7819e04aa58d961518367ce6ad3159a28300ca097967f630044d181be34

# Flight Control CLI Downloads
REG_FCA_URI=rhem/flightctl-cli-artifacts-rhel9
REG_FCA_DEST=quay.io/acm-d/flightctl-cli-artifacts-rhel9
REG_FCA_DIGEST=sha256:3491ec932d90112e89f3a4cebe5bdd9ed6a7811f116df43bab8bb5f827129361

# Flight Control Periodic Job Manager
REG_FP_URI=rhem/flightctl-periodic-rhel9
REG_FP_DEST=quay.io/acm-d/flightctl-periodic-rhel9
REG_FP_DIGEST=sha256:ee59f307e468e2b7b38f7c040898d587d441f8fb3d59cb022ae23e4717739e3f

# Flight Control Asynchronous Job worker
REG_FW_URI=rhem/flightctl-worker-rhel9
REG_FW_DEST=quay.io/acm-d/flightctl-worker-rhel9
REG_FW_DIGEST=sha256:1b1f6f85af0910f1acd029f54a608b25d3a2977c3d8b323266391543324305b4

# Flight Control UI
REG_FU_URI=rhem/flightctl-ui-rhel9
REG_FU_DEST=quay.io/acm-d/flightctl-ui-rhel9
REG_FU_DIGEST=sha256:940c0564ced75b7912d3ffc923a1f6bab9aed0f4a52962f7f894d08937b7d37e

# Flight Control UI (OCP) 
REG_FUO_URI=rhem/flightctl-ui-ocp-rhel9
REG_FUO_DEST=quay.io/acm-d/flightctl-ui-ocp-rhel9
REG_FUO_DIGEST=sha256:973eb3ca3da32c87ba308928a21fbd25514b2f6a6662300d4928479cb554cff3

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
# openshift4/ose-cli-rhel9
mirror_registry_image $REG_OCR_URI $REG_OCR_DIGEST $REG_OCR_VERSION $REG_OCR_DEST $AUTHFILE

# rhel9/redis-7
mirror_registry_image $REG_R7_URI $REG_R7_DIGEST $REG_R7_VERSION $REG_R7_DEST $AUTHFILE

# memcached
#mirror_registry_image $REG_MC_URI $REG_MC_DIGEST_A1 $REG_MC_VERSION_A $REG_MC_DEST $AUTHFILE
#mirror_registry_image $REG_MC_URI $REG_MC_DIGEST_A2 $REG_MC_VERSION_A $REG_MC_DEST $AUTHFILE

#mirror_registry_image $REG_MC_URI $REG_MC_DIGEST_B1 $REG_MC_VERSION_B $REG_MC_DEST $AUTHFILE
#mirror_registry_image $REG_MC_URI $REG_MC_DIGEST_B2 $REG_MC_VERSION_B $REG_MC_DEST $AUTHFILE

## Flight Control API Server
#mirror_registry_image $REG_FA_URI  $REG_FA_DIGEST  $REG_FC_VERSION $REG_FA_DEST  $AUTHFILE
## Flight Control CLI Downloads
#mirror_registry_image $REG_FCA_URI $REG_FCA_DIGEST $REG_FC_VERSION $REG_FCA_DEST $AUTHFILE
## Flight Control Periodic Job Manager
#mirror_registry_image $REG_FP_URI  $REG_FP_DIGEST  $REG_FC_VERSION $REG_FP_DEST  $AUTHFILE
## Flight Control Asynchronous Job worker
#mirror_registry_image $REG_FW_URI  $REG_FW_DIGEST  $REG_FC_VERSION $REG_FW_DEST  $AUTHFILE
## Flight Control UI
#mirror_registry_image $REG_FU_URI  $REG_FU_DIGEST  $REG_FC_VERSION $REG_FU_DEST  $AUTHFILE
## Flight Control UI (OCP) 
#mirror_registry_image $REG_FUO_URI $REG_FUO_DIGEST $REG_FC_VERSION $REG_FUO_DEST $AUTHFILE

# ---------------------------------------------------------------------------
echo "============== End mirror jobs =============="
# Clean up authfile
rm -f $AUTHFILE
