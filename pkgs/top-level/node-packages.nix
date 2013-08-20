{ pkgs, stdenv, nodejs, fetchurl, neededNatives, self }:

{
  nativeDeps = {
    "node-expat"."*" = [ pkgs.expat ];
    "rbytes"."0.0.2" = [ pkgs.openssl ];
  };

  buildNodePackage = import ../development/web/nodejs/build-node-package.nix {
    inherit stdenv nodejs neededNatives;
    inherit (pkgs) runCommand;
  };

  patchLatest = srcAttrs:
    let src = fetchurl srcAttrs; in pkgs.runCommand src.name {} ''
      mkdir unpack
      cd unpack
      tar xf ${src}
      mv */ package 2>/dev/null || true
      sed -i -e "s/: \"latest\"/: \"*\"/" package/package.json
      tar cf $out *
    '';

  /* Put manual packages below here (ideally eventually managed by npm2nix */
} // import ./node-packages-generated.nix { inherit self fetchurl; inherit (pkgs) lib; }
