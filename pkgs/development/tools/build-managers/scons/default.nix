{ callPackage, python2, python3 }:

let
  mkScons = args: callPackage (import ./make-scons.nix args) {
    python = python3;
  };
in {
}
