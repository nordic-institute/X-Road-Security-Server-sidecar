#!/bin/bash
set -euo pipefail

#dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" >&/dev/null && pwd)"
dir="$(pwd)"
# Default arguments
version="${1:-6.25.0}"
tag="${2:-xroad-security-server-sidecar}"
instance_country="${3:-fi}"

build() {
  echo -e "\n############################################################################################"
  echo "# BUILDING $tag:$version$2 using ${1#$dir/}"
  echo -e "############################################################################################\n"
  docker build -f "$1" --build-arg "VERSION=$version" --build-arg "TAG=$tag" -t "$tag:$version$2" "$dir"
}

# Vanilla instance - non country specific
build "$dir/slim/Dockerfile" "-slim"
build "$dir/Dockerfile" ""
build "$dir/kubernetesBalancer/slim/primary/Dockerfile" "-primary-slim"
build "$dir/kubernetesBalancer/slim/secondary/Dockerfile" "-secondary-slim"
build "$dir/kubernetesBalancer/primary/Dockerfile" "-primary"
build "$dir/kubernetesBalancer/secondary/Dockerfile" "-secondary"

# Country instances
build "$dir/slim/${instance_country}/Dockerfile" "-slim-${instance_country}"
build "$dir/${instance_country}/Dockerfile" "-${instance_country}"
build "$dir/kubernetesBalancer/slim/${instance_country}/primary/Dockerfile" "-slim-primary-${instance_country}"
build "$dir/kubernetesBalancer/slim/${instance_country}/secondary/Dockerfile" "-slim-secondary-${instance_country}"
build "$dir/kubernetesBalancer/${instance_country}/primary/Dockerfile" "-primary-${instance_country}"
build "$dir/kubernetesBalancer/${instance_country}/secondary/Dockerfile" "-secondary-${instance_country}"
