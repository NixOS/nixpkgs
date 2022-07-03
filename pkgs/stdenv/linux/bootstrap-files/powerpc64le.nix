#
# Files came from this Hydra build:
#
#   https://hydra.nixos.org/build/172142499
#
# Which used nixpkgs revision 49a83445c28c4ffb8a1a90a1f68e6150ea48893b
# to instantiate:
#
#   /nix/store/gj272sd56gsj6qpyzh4njpfzwdhviliz-stdenv-bootstrap-tools-powerpc64le-unknown-linux-gnu.drv
#
# and then built:
#
#   /nix/store/n81pljbd8m0xgypm84krc2bnvqgjrfxx-stdenv-bootstrap-tools-powerpc64le-unknown-linux-gnu
#
{
  busybox = import <nix/fetchurl.nix> {
    url = "http://tarballs.nixos.org/stdenv-linux/powerpc64le/49a83445c28c4ffb8a1a90a1f68e6150ea48893b/busybox";
    sha256 = "sha256-UscnfGKOZAKLkPcRtwrbT5Uj8m3Kj9jhkKp9MUc1eCY=";
    executable = true;
  };
  bootstrapTools =import <nix/fetchurl.nix> {
    url = "http://tarballs.nixos.org/stdenv-linux/powerpc64le/49a83445c28c4ffb8a1a90a1f68e6150ea48893b/bootstrap-tools.tar.xz";
    sha256 = "sha256-A20GKGn3rM8K2JcU0SApRp3+avUE+bIm1h632AitRzU=";
  };
}
