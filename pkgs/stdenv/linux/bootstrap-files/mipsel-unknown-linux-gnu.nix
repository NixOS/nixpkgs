#
# Files came from this Hydra build:
#
#   https://hydra.nixos.org/build/185311909
#
# Which used nixpkgs revision 5bd14b3cfe2f87a2e2b074645aba39c69563e4bc
# to instantiate:
#
#   /nix/store/184fa520zv8ls9fzcqyfa5dmkp8kf6xr-stdenv-bootstrap-tools-mipsel-unknown-linux-gnu.drv
#
# and then built:
#
#   /nix/store/i46mrzinxi9a5incliwhksmk947ff4wn-stdenv-bootstrap-tools-mipsel-unknown-linux-gnu
#
{
  busybox = import <nix/fetchurl.nix> {
    url = "http://tarballs.nixos.org/stdenv-linux/mipsel/5bd14b3cfe2f87a2e2b074645aba39c69563e4bc/busybox";
    hash = "sha256-EhuzjL52VEIOfEcFdVGZaDMClQbMc9V9ISrTUNaA7HQ=";
    executable = true;
  };
  bootstrapTools = import <nix/fetchurl.nix> {
    url = "http://tarballs.nixos.org/stdenv-linux/mipsel/5bd14b3cfe2f87a2e2b074645aba39c69563e4bc/bootstrap-tools.tar.xz";
    hash = "sha256-OEGgLJOLnV+aobsb+P8mY3Dp8qbeVODBH6x3aUE/MGM=";
  };
}
