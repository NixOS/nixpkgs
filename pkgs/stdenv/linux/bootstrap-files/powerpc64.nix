#
# Files came from this Hydra build:
#
#   https://hydra.nixos.org/build/178153111
#
# Which used nixpkgs revision 7c7d71d90e7d715847809a65fa2463c668e58ab3
# to instantiate:
#
#   /nix/store/2cvsxg39jq2j119cx349zybibv3p0ns9-stdenv-bootstrap-tools-powerpc64-unknown-linux-gnu.drv
#
# and then built:
#
#   /nix/store/c8c3qa2bpmi0j6zx8xg2ylz9q0wixq3z-stdenv-bootstrap-tools-powerpc64-unknown-linux-gnu
#
{
  busybox = import <nix/fetchurl.nix> {
    url = "http://tarballs.nixos.org/stdenv-linux/powerpc64/7c7d71d90e7d715847809a65fa2463c668e58ab3/busybox";
    hash = "sha256-oxKpW9QJ4CjXdQWwYOKkCRgjhRj91+1GSHAf5uFX44Q=";
    executable = true;
  };
  bootstrapTools = import <nix/fetchurl.nix> {
    url = "http://tarballs.nixos.org/stdenv-linux/powerpc64/7c7d71d90e7d715847809a65fa2463c668e58ab3/bootstrap-tools.tar.xz";
    hash = "sha256-GAvEC7Ow1FQKO3jLdf5nFXvJAvOqcM90kUEhHWJh+FY=";
  };
}
