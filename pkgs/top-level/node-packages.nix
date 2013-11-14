{ pkgs, stdenv, nodejs, fetchurl, fetchgit, neededNatives, self, generated ? ./node-packages-generated.nix }:

rec {
  nativeDeps = {
    "node-expat" = [ pkgs.expat ];
    "rbytes" = [ pkgs.openssl ];
    "phantomjs" = [ pkgs.phantomjs ];
  };

  buildNodePackage = import ../development/web/nodejs/build-node-package.nix {
    inherit stdenv nodejs neededNatives;
    inherit (pkgs) runCommand;
  };

  patchSource = fn: srcAttrs:
    let src = fn srcAttrs; in pkgs.runCommand src.name {} ''
      mkdir unpack
      cd unpack
      unpackFile ${src}
      mv */ package 2>/dev/null || true
      sed -i -e "s/: \"latest\"/: \"*\"/" -e "s/: \"git\(\+\(ssh\|http\|https\)\)\?\:\/\/[^\"]*\"/: \"*\"/" package/package.json
      mv * $out
    '';

  # Backwards compat
  patchLatest = patchSource fetchurl;

  /* Put manual packages below here (ideally eventually managed by npm2nix */
} // import generated { inherit self fetchurl fetchgit; inherit (pkgs) lib; }
