let {
  system = "i686-linux";

  stdenvs = (import ../../system/stdenvs.nix) {
    system = "i686-linux";
    allPackages = import ../../system/all-packages-generic.nix;
  };

  stdenv = stdenvs.stdenvLinuxBoot2;

  test = derivation {
    name = "simple-test";
    inherit system stdenv;
    builder = ./builder.sh;
  };

  body = test;
}
