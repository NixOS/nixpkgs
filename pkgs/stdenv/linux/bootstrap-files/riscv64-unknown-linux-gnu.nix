#
# Files came from this Hydra build:
#
#   https://hydra.nixos.org/build/246376732
#
# Which used nixpkgs revision 160cedc144aced7a35a91440b46b74ffacd52682
# to instantiate:
#
#   /nix/store/cpiajh4l83b08pynwiwkpxj53d78pcxr-stdenv-bootstrap-tools-riscv64-unknown-linux-gnu.drv
#
# and then built:
#
#   /nix/store/8a92pj40awdw585mcb9dvm4nyb03k3q3-stdenv-bootstrap-tools-riscv64-unknown-linux-gnu
#
{
  busybox = import <nix/fetchurl.nix> {
    url = "http://tarballs.nixos.org/stdenv-linux/riscv64/160cedc144aced7a35a91440b46b74ffacd52682/busybox";
    sha256 = "sha256-OGO96QUzs2n5pGipn/V87AxzUY9OWKZl417nE8HdZIE=";
    executable = true;
  };

  bootstrapTools = import <nix/fetchurl.nix> {
    url = "http://tarballs.nixos.org/stdenv-linux/riscv64/160cedc144aced7a35a91440b46b74ffacd52682/bootstrap-tools.tar.xz";
    sha256 = "sha256-0LxRd7fdafQezNJ+N2tuOfm0KEwgfRSts5fhP0e0r0s=";
  };
}
