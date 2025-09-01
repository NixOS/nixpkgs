{
  lib,
  stdenv,
  fetchurl,
  fetchzip,
  callPackage,
  newScope,
  recurseIntoAttrs,
  ocamlPackages_4_14,
  fetchpatch,
  makeWrapper,
}@args:
let
  lib = import ../build-support/rocq/extra-lib.nix { inherit (args) lib; };
in
let
  mkRocqPackages' =
    self: rocq-core:
    let
      callPackage = self.callPackage;
    in
    {
      inherit rocq-core lib;
      rocqPackages = self // {
        __attrsFailEvaluation = true;
        recurseForDerivations = false;
      };

      metaFetch = import ../build-support/coq/meta-fetch/default.nix {
        inherit
          lib
          stdenv
          fetchzip
          fetchurl
          ;
      };
      mkRocqDerivation = lib.makeOverridable (callPackage ../build-support/rocq { });

      bignums = callPackage ../development/rocq-modules/bignums { };
      hierarchy-builder = callPackage ../development/rocq-modules/hierarchy-builder { };
      parseque = callPackage ../development/rocq-modules/parseque { };
      rocq-elpi = callPackage ../development/rocq-modules/rocq-elpi { };
      stdlib = callPackage ../development/rocq-modules/stdlib { };

      filterPackages = doesFilter: if doesFilter then filterRocqPackages self else self;
    };

  filterRocqPackages =
    set:
    lib.listToAttrs (
      lib.concatMap (
        name:
        let
          v = set.${name} or null;
        in
        lib.optional (!v.meta.rocqFilter or false) (
          lib.nameValuePair name (
            if lib.isAttrs v && v.recurseForDerivations or false then filterRocqPackages v else v
          )
        )
      ) (lib.attrNames set)
    );
  mkRocq =
    version:
    callPackage ../applications/science/logic/rocq-core {
      inherit
        version
        ocamlPackages_4_14
        ;
    };
in
rec {

  /*
    The function `mkRocqPackages` takes as input a derivation for Rocq and produces
    a set of libraries built with that specific Rocq. More libraries are known to
    this function than what is compatible with that version of Rocq. Therefore,
    libraries that are not known to be compatible are removed (filtered out) from
    the resulting set. For meta-programming purposes (inspecting the derivations
    rather than building the libraries) this filtering can be disabled by setting
    a `dontFilter` attribute into the Rocq derivation.
  */
  mkRocqPackages =
    rocq-core:
    let
      self = lib.makeScope newScope (lib.flip mkRocqPackages' rocq-core);
    in
    self.filterPackages (!rocq-core.dontFilter or false);

  rocq-core_9_0 = mkRocq "9.0";
  rocq-core_9_1 = mkRocq "9.1";

  rocqPackages_9_0 = mkRocqPackages rocq-core_9_0;
  rocqPackages_9_1 = mkRocqPackages rocq-core_9_1;

  rocqPackages = recurseIntoAttrs rocqPackages_9_0;
  rocq-core = rocqPackages.rocq-core;
}
