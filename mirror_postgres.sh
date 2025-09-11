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

# openshift4/ose-baremetal-cluster-api-controllers-rhel9
REG_PM3_URI=openshift4/ose-baremetal-cluster-api-controllers-rhel9
REG_PM3_DEST=quay.io/acm-d/ose-baremetal-cluster-api-controllers-rhel9
REG_PM3_VERSION=v4.19.0-202507011209.p0.g06a66db.assembly.stream.el9
REG_PM3_DIGEST=sha256:f855d5ce17d3ac4560afc73c35d03f045f84551fdccc00312c890288a889b9ce

# openshift4/ose-cli-rhel9
REG_OCR_URI=openshift4/ose-cli-rhel9
REG_OCR_DEST=quay.io/acm-d/ose-cli-rhel9
REG_OCR_VERSION=v4.19.0-202506161807.p0.gfa1fd95.assembly.stream.el9
REG_OCR_DIGEST=sha256:2bc7ba0ff29191952dbd7bff883b378c868b3728f4cd1b491e23ef4c593e0bde

# openshift4/ose-cluster-api-rhel9
REG_CAPI_URI=openshift4/ose-cluster-api-rhel9
REG_CAPI_DEST=quay.io/acm-d/ose-cluster-api-rhel9
REG_CAPI_VERSION=v4.19.0-202507011209.p0.g479f0c4.assembly.stream.el9
REG_CAPI_DIGEST=sha256:9a72b8081a57846d942981ced07da86ad8e197309a1bc3c9d53876528b58f8ec

# rhel9/redis-7
REG_R7_URI=rhel9/redis-7
REG_R7_DEST=quay.io/acm-d/redis-7
REG_R7_VERSION=9.6-1749629182
REG_R7_DIGEST=sha256:a3bb7c5987829cf7d886d9418ac24f55783de71a6cbbbcde0fa17e609bb58a2e

# Memcached
REG_MC_URI=rhel9/memcached
REG_MC_DEST=quay.io/acm-d/memcached
REG_MC_VERSION=9.6-1750861417
REG_MC_DIGEST=sha256:200461278f3b291b0a77cf8fddd32100aecaad96d1e55b6bfbb423944096c53a

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

# AWS Cluster API Provider
REG_OACAC_URI=openshift4/ose-aws-cluster-api-controllers-rhel9
REG_OACAC_DEST=quay.io/acm-d/ose-aws-cluster-api-controllers-rhel9
REG_OACAC_VERSION=v4.19.0-202507011209.p0.g8024520.assembly.stream.el9
REG_OACAC_DIGEST=sha256:cf13b0658271cd0dbd1ce6dcc350e64c5459ef02ba4dc88a0031de9d6f26ffd1

# Search rhel9/postgresql-16:9.5-1732622748
REG_SEARCH_PG_URI=rhel9/postgresql-16
REG_SEARCH_PG_DEST=quay.io/acm-d/postgresql-16
REG_SEARCH_PG_VERSION=9.5-1732622748
REG_SEARCH_PG_DIGEST=sha256:d8b5726688d4e0d37f39fc12131a04f057f1093744ce06e82cf777e1e6f3e0ae

# Search rhel8/postgresql-16:1-1752582967 - all arches
REG_SEARCH_PG_RHEL8_URL=rhel8/postgresql-16
REG_SEARCH_PG_RHEL8_DEST=quay.io/acm-d/postgresql-16
REG_SEARCH_PG_RHEL8_AMD_VERSION=1-1752582967-amd
REG_SEARCH_PG_RHEL8_ARM_VERSION=1-1752582967-arm
REG_SEARCH_PG_RHEL8_PPC_VERSION=1-1752582967-ppc
REG_SEARCH_PG_RHEL8_S390X_VERSION=1-1752582967-s390x
REG_SEARCH_PG_RHEL8_VERSION=1-1752582967
REG_SEARCH_PG_RHEL8_AMD_DIGEST=sha256:cf010a0fb1ca9027aaf9fd6abe97d23e28abe3b33eab8891b15fe3060e9af428
REG_SEARCH_PG_RHEL8_ARM_DIGEST=sha256:3685a8c1b5296c7391749d726e7071d96f1350ae566f4b65575c35b4acf2f8b9
REG_SEARCH_PG_RHEL8_PPC_DIGEST=sha256:e6d8e591cfaf90a8b91f179b8d93b4999aabdae67dbc14f919e031d539aefdfe
REG_SEARCH_PG_RHEL8_S390X_DIGEST=sha256:98940adb4713ca39630333923d71eff9b6dfd11843c1e3cd7d482d0e827a3f52
REG_SEARCH_PG_RHEL8_MLDIGEST=sha256:d4abbd9492347e0aa7e1b0ff967e74d4b6a4edd6fd20d896f2f2ae03c623181c

# Proxy for Kubernetes RBAC authorization
REG_OKRP_PG_URI=openshift4/ose-kube-rbac-proxy-rhel9
REG_OKRP_PG_DEST=quay.io/acm-d/ose-kube-rbac-proxy-rhel9
REG_OKRP_PG_VERSION=v4.19.0-202507291138.p0.g5912775.assembly.stream.el9
REG_OKRP_PG_DIGEST=sha256:c1a84feb88d53e93bdcf2cd5f76e2cbb18541c8b0e2979c132a888d6c280b664

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

# Cluster API Provider Metal3
#mirror_registry_image $REG_PM3_URI $REG_PM3_DIGEST $REG_PM3_VERSION $REG_PM3_DEST $AUTHFILE

# openshift4/ose-cli-rhel9
#mirror_registry_image $REG_OCR_URI $REG_OCR_DIGEST $REG_OCR_VERSION $REG_OCR_DEST $AUTHFILE

# Cluster API
#mirror_registry_image $REG_CAPI_URI $REG_CAPI_DIGEST $REG_CAPI_VERSION $REG_CAPI_DEST $AUTHFILE

# rhel9/redis-7
#mirror_registry_image $REG_R7_URI $REG_R7_DIGEST $REG_R7_VERSION $REG_R7_DEST $AUTHFILE

# memcached
#mirror_registry_image $REG_MC_URI $REG_MC_DIGEST $REG_MC_VERSION $REG_MC_DEST $AUTHFILE

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

# AWS Cluster API Provider
#mirror_registry_image $REG_OACAC_URI $REG_OACAC_DIGEST $REG_OACAC_VERSION $REG_OACAC_DEST $AUTHFILE

# Search rhel9/postgresql-16:9.5-1732622748
#mirror_registry_image $REG_SEARCH_PG_URI $REG_SEARCH_PG_DIGEST $REG_SEARCH_PG_VERSION $REG_SEARCH_PG_DEST $AUTHFILE

# Search rhel8/postgresql-16:1-1752582967 - all arches
#mirror_registry_image $REG_SEARCH_PG_RHEL8_URL $REG_SEARCH_PG_RHEL8_AMD_DIGEST $REG_SEARCH_PG_RHEL8_AMD_VERSION $REG_SEARCH_PG_RHEL8_DEST $AUTHFILE
#mirror_registry_image $REG_SEARCH_PG_RHEL8_URL $REG_SEARCH_PG_RHEL8_ARM_DIGEST $REG_SEARCH_PG_RHEL8_ARM_VERSION $REG_SEARCH_PG_RHEL8_DEST $AUTHFILE
#mirror_registry_image $REG_SEARCH_PG_RHEL8_URL $REG_SEARCH_PG_RHEL8_PPC_DIGEST $REG_SEARCH_PG_RHEL8_PPC_VERSION $REG_SEARCH_PG_RHEL8_DEST $AUTHFILE
#mirror_registry_image $REG_SEARCH_PG_RHEL8_URL $REG_SEARCH_PG_RHEL8_S390X_DIGEST $REG_SEARCH_PG_RHEL8_S390X_VERSION $REG_SEARCH_PG_RHEL8_DEST $AUTHFILE

# Search rhel9/postgresql-16:1-1752582967
#mirror_registry_image $REG_SEARCH_PG_RHEL8_URL $REG_SEARCH_PG_RHEL8_MLDIGEST $REG_SEARCH_PG_RHEL8_VERSION $REG_SEARCH_PG_RHEL8_DEST $AUTHFILE

# Proxy for Kubernetes RBAC authorization
#mirror_registry_image $REG_OKRP_PG_URI $REG_OKRP_PG_DIGEST $REG_OKRP_PG_VERSION $REG_OKRP_PG_DEST $AUTHFILE
# ---------------------------------------------------------------------------
echo "============== End mirror jobs =============="
# Clean up authfile
rm -f $AUTHFILE
