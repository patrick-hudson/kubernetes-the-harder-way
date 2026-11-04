# Common variables reused in other scripts

etcd_version=3.6.16
k8s_version=1.36.6
cri_version=1.36.0
runc_version=1.5.2
containerd_version=2.3.7
cni_plugins_version=1.9.1
cni_spec_version=1.0.0

case $(uname -m) in
  arm64|aarch64) arch=arm64;;
  x86_64|amd64) arch=amd64;;
  *) echo "unsupported CPU architecture"; exit 1
esac
