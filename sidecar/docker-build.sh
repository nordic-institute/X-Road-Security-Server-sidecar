#!/bin/bash
set -euo pipefail

dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" >&/dev/null && pwd)"
version="${1:-7.0.0}"
xroad_version="${2:-7.0.0}"
tag="${3:-xroad-security-server-sidecar}"
repo="${4-}"
dist="${5-}"
repo_key="${6-}"

build() {
  echo "BUILDING $tag:$version$2 using ${1#$dir/}"
  local build_args=(--build-arg "VERSION=$version" --build-arg "TAG=$tag")
  [[ -n $repo ]] && build_args+=(--build-arg "REPO=$repo")
  [[ -n $repo_key ]] && build_args+=(--build-arg "REPO_KEY=$repo_key")
  [[ -n $dist ]] && build_args+=(--build-arg "DIST=$dist")
  [[ -n ${LABEL-} ]] && build_args+=(--label "$LABEL")
  docker build -f "$1" "${build_args[@]}" -t "$tag:$version$2" "$dir"
}

build_variant() {
  echo "BUILDING variant $tag:$version$1-$2"
  docker build -f "$dir/Dockerfile-variant" \
    --build-arg "VERSION=$version" \
    --build-arg "XROAD_VERSION=$xroad_version" \
    --build-arg "FROM=$tag:$version$1" \
    --build-arg "VARIANT=$2" \
    -t "$tag:$version$1-$2" "$dir"
}

build "$dir/slim/Dockerfile" "-slim"
build_variant "-slim" "fi"
build_variant "-slim" "fo"
build_variant "-slim" "is"

build "$dir/Dockerfile" ""
build_variant "" "fi"
build_variant "" "ee"
build_variant "" "fo"
build_variant "" "is"

build "$dir/kubernetesBalancer/slim/primary/Dockerfile" "-slim-primary"
build "$dir/kubernetesBalancer/slim/secondary/Dockerfile" "-slim-secondary"
build "$dir/kubernetesBalancer/primary/Dockerfile" "-primary"
build "$dir/kubernetesBalancer/secondary/Dockerfile" "-secondary"

build_variant "-slim-primary" "fi"
build_variant "-slim-secondary" "fi"
build_variant "-slim-primary" "is"
build_variant "-slim-secondary" "is"

build_variant "-primary" "fi"
build_variant "-secondary" "fi"
build_variant "-primary" "is"
build_variant "-secondary" "is"
build_variant "-primary" "ee"
build_variant "-secondary" "ee"
