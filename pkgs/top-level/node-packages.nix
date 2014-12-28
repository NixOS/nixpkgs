{ pkgs, stdenv, nodejs, fetchurl, fetchgit, neededNatives, self, generated ? ./node-packages-generated.nix }:

rec {
  nativeDeps = {
    "node-expat" = [ pkgs.expat ];
    "node-stringprep" = [ pkgs.icu pkgs.which ];
    "rbytes" = [ pkgs.openssl ];
    "phantomjs" = [ pkgs.phantomjs ];
    "node-protobuf" = [ pkgs.protobuf ];
  };

  buildNodePackage = import ../development/web/nodejs/build-node-package.nix {
    inherit stdenv nodejs neededNatives;
    inherit (pkgs) runCommand;
  };

  patchSource = fn: srcAttrs: fn srcAttrs;

  # Backwards compat
  patchLatest = patchSource fetchurl;

  /* Put manual packages below here (ideally eventually managed by npm2nix */
} // import generated { inherit self fetchurl fetchgit; inherit (pkgs) lib; }
