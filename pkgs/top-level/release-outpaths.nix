#!/usr/bin/env nix-shell
# When using as a callable script, passing `--argstr path some/path` overrides $PWD.
#!nix-shell -p nix -i "nix-env -qaP --no-name --out-path --arg checkMeta true -f pkgs/top-level/release-outpaths.nix"

# Vendored from:
#   https://raw.githubusercontent.com/NixOS/ofborg/74f38efa7ef6f0e8e71ec3bfc675ae4fb57d7491/ofborg/src/outpaths.nix
{ checkMeta
, includeBroken ? true  # set this to false to exclude meta.broken packages from the output
, path ? ./../..

# used by pkgs/top-level/release-attrnames-superset.nix
, attrNamesOnly ? false

# Set this to `null` to build for builtins.currentSystem only
, systems ? [
    "aarch64-linux"
    "aarch64-darwin"
    #"i686-linux"  # !!!
    "x86_64-linux"
    "x86_64-darwin"
  ]
}:
let
  lib = import (path + "/lib");
  hydraJobs = import (path + "/pkgs/top-level/release.nix")
    # Compromise: accuracy vs. resources needed for evaluation.
    {
      inherit attrNamesOnly;
      supportedSystems =
        if systems == null
        then [ builtins.currentSystem ]
        else systems;
      nixpkgsArgs = {
        config = {
          allowAliases = false;
          allowBroken = includeBroken;
          allowUnfree = false;
          allowInsecurePredicate = x: true;
          checkMeta = checkMeta;

          handleEvalIssue = reason: errormsg:
            let
              fatalErrors = [
                "unknown-meta"
                "broken-outputs"
              ];
            in
            if builtins.elem reason fatalErrors
            then abort errormsg
            # hydra does not build unfree packages, so tons of them are broken yet not marked meta.broken.
            else if !includeBroken && builtins.elem reason [ "broken" "unfree" ]
            then throw "broken"
            else if builtins.elem reason [ "unsupported" ]
            then throw "unsupported"
            else true;

          inHydra = true;
        };
      };
    };
  recurseIntoAttrs = attrs: attrs // { recurseForDerivations = true; };

  # hydraJobs leaves recurseForDerivations as empty attrmaps;
  # that would break nix-env and we also need to recurse everywhere.
  tweak = lib.mapAttrs
    (name: val:
      if name == "recurseForDerivations" then true
      else if lib.isAttrs val && val.type or null != "derivation"
      then recurseIntoAttrs (tweak val)
      else val
    );

  # Some of these contain explicit references to platform(s) we want to avoid;
  # some even (transitively) depend on ~/.nixpkgs/config.nix (!)
  blacklist = [
    "tarball"
    "metrics"
    "manual"
    "darwin-tested"
    "unstable"
    "stdenvBootstrapTools"
    "moduleSystem"
    "lib-tests" # these just confuse the output
  ];

in
tweak (builtins.removeAttrs hydraJobs blacklist)
