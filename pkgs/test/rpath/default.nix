let {
  system = "i686-linux";

  stdenvs = (import ../../system/stdenvs.nix) {
    inherit system;
    allPackages = import ../../system/all-packages-generic.nix;
  };

  stdenv = stdenvs.stdenvLinuxBoot2;

  test = stdenv.mkDerivation {
    name = "rpath-test";
    builder = ./builder.sh;
    src = ./src;
  };

  body = test;
}
