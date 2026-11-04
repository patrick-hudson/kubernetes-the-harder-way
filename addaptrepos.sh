#!/usr/bin/env bash

if [[ "$EUID" -ne 0 ]]; then
  echo "this script must be run as root" >&2
  exit 1
fi

apt install -y apt-transport-https ca-certificates

if [[ ! -f /etc/apt/sources.list.d/kubernetes.list ]]; then
  curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.36/deb/Release.key \
    | gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
  echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.36/deb/ /' \
    | tee /etc/apt/sources.list.d/kubernetes.list
fi

if [[ ! -f /etc/apt/sources.list.d/helm-stable-debian.sources ]]; then
  rm -f /etc/apt/sources.list.d/helm-stable-debian.list /usr/share/keyrings/helm.gpg
  curl -fsSL https://packages.buildkite.com/helm-linux/helm-debian/gpgkey -o /etc/apt/keyrings/helm.asc
  if [[ "$(gpg --import --import-options=show-only --with-colons /etc/apt/keyrings/helm.asc | awk -F: '$1 == "fpr" {print $10}' | head -n 1)" \
      != "DDF78C3E6EBB2D2CC223C95C62BA89D07698DBC6" ]]; then
    echo "unexpected Helm APT key" >&2
    rm -f /etc/apt/keyrings/helm.asc
    exit 1
  fi
  chmod 644 /etc/apt/keyrings/helm.asc
  cat <<EOF | tee /etc/apt/sources.list.d/helm-stable-debian.sources
Types: deb
URIs: https://packages.buildkite.com/helm-linux/helm-debian/any/
Suites: any
Components: main
Signed-By: /etc/apt/keyrings/helm.asc
EOF
fi

apt update
