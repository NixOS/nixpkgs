#
# Files came from this Hydra build:
#
#   https://hydra.nixos.org/build/188389586
#
# Which used nixpkgs revision 97d9c84e1df4397b43ecb39359f1bd003cd44585
# to instantiate:
#
#   /nix/store/hakn8s85s9011v61r6svp5qy8x1y64fv-stdenv-bootstrap-tools-mips64el-unknown-linux-gnuabin32.drv
#
# and then built:
#
#   /nix/store/rjgybpnf3yiqyhvl2n2lx31jf800fii2-stdenv-bootstrap-tools-mips64el-unknown-linux-gnuabin32
#
{
  busybox = import <nix/fetchurl.nix> {
    url = "http://tarballs.nixos.org/stdenv-linux/mips64el/97d9c84e1df4397b43ecb39359f1bd003cd44585/busybox";
    sha256 = "sha256-4N3G1qYA7vitjhsIW17pR6UixIuzrq4vZXa8F0/X4iI=";
    executable = true;
  };
  bootstrapTools = import <nix/fetchurl.nix> {
    url = "http://tarballs.nixos.org/stdenv-linux/mips64el/97d9c84e1df4397b43ecb39359f1bd003cd44585/bootstrap-tools.tar.xz";
    sha256 = "sha256-LWrpN6su2yNVurUyhZP34OiZyzgh7MfN13fIIbou8KI=";
  };
}
