let {
  system = "i686-linux";

  stdenvs = (import ../../system/stdenvs.nix) {
    inherit system;
    allPackages = import ../../system/all-packages-generic.nix;
  };

  stdenv = stdenvs.stdenvNix;

  test = stdenv.mkDerivation {
    name = "simple-test";
    builder = ./builder.sh;
  };

  body = test;
}
