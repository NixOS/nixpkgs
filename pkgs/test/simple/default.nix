let {
  system = "i686-linux";

  stdenvInitial = (import ../../stdenv/initial) {
    name = "stdenv-initial";
    inherit system;
  };

  stdenv = (import ../../stdenv/native) {stdenv = stdenvInitial;};

  test = derivation {
    name = "simple-test";
    inherit system stdenv;
    builder = ./builder.sh;
  };

  body = test;
}
