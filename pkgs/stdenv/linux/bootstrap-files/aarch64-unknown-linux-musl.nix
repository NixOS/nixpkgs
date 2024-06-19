#
# Files came from this Hydra build:
#
#   https://hydra.nixos.org/build/246470544
#
# …which used nixpkgs revision dd5621df6dcb90122b50da5ec31c411a0de3e538
# to instantiate:
#
#   /nix/store/g480ass2vjmakaq03z7k2j95xnxh206a-stdenv-bootstrap-tools.drv
#
# …and then built:
#
#   /nix/store/95lm0y33dayag4542s8bi83s31bw68dr-stdenv-bootstrap-tools
#
{
  busybox = import <nix/fetchurl.nix> {
    url = "http://tarballs.nixos.org/stdenv/aarch64-unknown-linux-musl/dd5621df6dcb90122b50da5ec31c411a0de3e538/busybox";
    sha256 = "sha256-WuOaun7U5enbOy8SuuCo6G1fbGwsO16jhy/oM8K0lAs=";
    executable = true;
  };
  bootstrapTools = import <nix/fetchurl.nix> {
    url = "http://tarballs.nixos.org/stdenv/aarch64-unknown-linux-musl/dd5621df6dcb90122b50da5ec31c411a0de3e538/bootstrap-tools.tar.xz";
    hash = "sha256-ZY9IMOmx1VOn6uoFDpdJbTnPX59TEkrVCzWNtjQ8/QE=";
  };
}
