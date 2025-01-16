#
# Files came from this Hydra build:
#
#   https://hydra.nixos.org/build/262871650
#
# …which used nixpkgs revision a9858885e197f984d92d7fe64e9fff6b2e488d40
# to instantiate:
#
#   /nix/store/nxyvqvf7l9hvlkg3ca56gy3jkr5pqrn2-stdenv-bootstrap-tools.drv
#
# …and then built:
#
#   /nix/store/dk28gq49ckmgwpnx36709ff0hxnkmqpk-stdenv-bootstrap-tools
#
{
  busybox = import <nix/fetchurl.nix> {
    url = "http://tarballs.nixos.org/stdenv-linux/aarch64/a9858885e197f984d92d7fe64e9fff6b2e488d40/busybox";
    executable = true;
    hash = "sha256-8areJJa2A0xauz5XqwZTgkHSb3qSdi7rTiCI05SaS0Y=";
  };
  bootstrapTools = import <nix/fetchurl.nix> {
    url = "http://tarballs.nixos.org/stdenv-linux/aarch64/a9858885e197f984d92d7fe64e9fff6b2e488d40/bootstrap-tools.tar.xz";
    hash = "sha256-Ag5/vwGqv8q9SwdJYmmcvtqcLJjVYNwhgcqQ0BHTTdg=";
  };
}
