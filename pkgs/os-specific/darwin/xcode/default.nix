{
  lib,
  requireFile,
  stdenv,
}: let
  releases = import ./releases.nix;

  mkName = xcodeAttrs: "xcode_" + lib.replaceStrings ["."] ["_"] xcodeAttrs.version;

  requireXcode = import ./require-xcode.nix {
    inherit lib requireFile stdenv;
  };

  mkXcode = xcodeAttrs: requireXcode {inherit (xcodeAttrs) version hash;};

  allXcodes = builtins.listToAttrs (
    builtins.map
    (xcodeAttrs: lib.nameValuePair (mkName xcodeAttrs) (mkXcode xcodeAttrs))
    releases
  );

  defaultVersion =
    if (stdenv.targetPlatform ? xcodeVer)
    then stdenv.targetPlatform.xcodeVer
    else "12.3";

  defaultXcode = allXcodes.${mkName {version = defaultVersion;}};
in
  lib.makeExtensible (_: allXcodes // {xcode = defaultXcode;})
