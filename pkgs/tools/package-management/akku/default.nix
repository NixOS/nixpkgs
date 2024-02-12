{ lib, newScope, stdenv, fetchurl }:
lib.makeScope newScope (self: rec {

  fetchAkku = { name, url, sha256, ... }:
    fetchurl {
      inherit url sha256;
    };

  akkuDerivation = self.callPackage ./akkuDerivation.nix { };
  akku = self.callPackage ./akku.nix { };

  akkuPackages = lib.recurseIntoAttrs (lib.makeScope self.newScope (akkuself:
    let
      makeAkkuPackage = name: { version, url, sha256, dependencies ? [ ], ... }: (akkuDerivation {
        inherit name version;
        src = fetchAkku { inherit name url; sha256 = "sha256-${sha256}"; };
        buildInputs = builtins.map (x: akkuself.${x}) dependencies;
      }).overrideAttrs (final: prev: { unpackPhase = "tar xf $src"; });
    in
    lib.mapAttrs makeAkkuPackage (lib.importTOML ./deps.toml)));
})
