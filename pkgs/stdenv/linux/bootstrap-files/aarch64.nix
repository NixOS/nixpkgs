{
  busybox = import <nix/fetchurl.nix> {
    url = http://nixos-arm.dezgeg.me/bootstrap-aarch64-2017-01-27-264d42b9c/busybox;
    sha256 = "12qcml1l67skpjhfjwy7gr10nc86gqcwjmz9ggp7knss8gq8pv7f";
    executable = true;
  };
  bootstrapTools = import <nix/fetchurl.nix> {
    url = http://nixos-arm.dezgeg.me/bootstrap-aarch64-2017-01-27-264d42b9c/bootstrap-tools.tar.xz;
    sha256 = "13h7lgkjyxrmfkx5k1w6rj3j4iqrk28pqagiwqcg8izrydy318bi";
  };
}
