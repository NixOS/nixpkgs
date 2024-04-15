# Runs in sandbox for all-attributes.nix's derivations.
# Evaluate an interval of Nixpkgs attribute paths, returning the out paths
{ attrPaths, path, shardCount, shardIndex }:

let
  pkgs = import path {
    system = "x86_64-linux";

    # Just evaluate as much as possible.
    config = {
      allowUnfree = true;
      allowInsecure = true;
      allowBroken = true;
    };
  };

  lib = pkgs.lib;

  inherit (lib) sublist splitString;

  numAttrs = builtins.length attrPaths;

  firstAttr = (numAttrs * shardIndex) / shardCount;

  lastAttr = (numAttrs * (shardIndex + 1)) / shardCount;

  shardAttrPaths = sublist firstAttr (lastAttr - firstAttr) attrPaths;

  result =
    lib.genAttrs
      # What we're returning as attributes represent paths into pkgs.
      shardAttrPaths
      tryEvalAttrPath;

  tryEvalAttrPath = attrPath:
    let
      attempt = builtins.tryEval value;
      attrPathElements = splitString "." attrPath;
      rawValue = lib.attrByPath attrPathElements { error = "MISSING"; } pkgs;
      value =
        if lib.head attrPathElements == "vmTools"
        then { error = "EXCLUDED"; }
        else if ! lib.isDerivation rawValue
        then { error = "NOT A DERIVATION"; }
        else if rawValue.meta.available or true == false
        then { error = "NOT AVAILABLE"; }
        else
          # This could be extended, but make sure to avoid infinite structures
          # and use deepSeq so that the whole structure is covered by tryEval.
          rawValue.drvPath or
            # TODO: A derivation path would be preferable for diffing
            #       https://github.com/NixOS/nixpkgs/pull/281536
            rawValue.outPath;
    in
      if attempt.success
      then attempt.value
      else { error = "EXCEPTION"; };
in
  result
