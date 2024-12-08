#
# Files came from this Hydra build:
#
#   https://hydra.nixos.org/build/182757245
#
# Which used nixpkgs revision ef3fe254f3c59455386bc92fe84164f9679b92b1
# to instantiate:
#
#   /nix/store/a2bvv663wjnyhq8m7v84aspsd3sgf9h6-stdenv-bootstrap-tools-mips64el-unknown-linux-gnuabi64.drv
#
# and then built:
#
#   /nix/store/aw3dmsrh22831l83vi3q9apg9qi3x8ms-stdenv-bootstrap-tools-mips64el-unknown-linux-gnuabi64
#
{
  busybox = import <nix/fetchurl.nix> {
    url = "http://tarballs.nixos.org/stdenv-linux/mips64el/ef3fe254f3c59455386bc92fe84164f9679b92b1/busybox";
    sha256 = "sha256-sTE58ofjqAqX3Xtq1g9wDxzIe6Vo//GHbicfqJoivDI=";
    executable = true;
  };
  bootstrapTools =import <nix/fetchurl.nix> {
    url = "http://tarballs.nixos.org/stdenv-linux/mips64el/ef3fe254f3c59455386bc92fe84164f9679b92b1/bootstrap-tools.tar.xz";
    sha256 = "sha256-tTgjeXpd2YgnfP4JvRuO0bXd2j8GqzBcd57JI3wH9x0=";
  };
}
