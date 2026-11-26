{
  lib,
  pkgs,
  stdenv,
  pythonPackagesExtensions,
  makeScopeWithSplicing',
  config,
}:
interpreter: packageOverrides:
let
  inherit (interpreter)
    pythonOnBuildForBuild
    pythonOnBuildForHost
    pythonOnBuildForTarget
    pythonOnHostForHost
    pythonOnTargetForTarget
    ;

  dirname = "python3Packages";

  ensurePythonModules =
    items:
    let
      exceptions = [
        stdenv
      ];
      providesSetupHook = lib.attrByPath [ "provides" "setupHook" ] false;
      valid =
        value: pythonPackages.hasPythonModule value || providesSetupHook value || lib.elem value exceptions;
      func =
        name: value:
        if lib.isDerivation value then
          lib.extendDerivation (
            valid value
            || throw "${name} should use `buildPythonPackage` or `toPythonModule` if it is to be part of the Python packages set."
          ) { } value
        else
          value;
    in
    lib.mapAttrs func items;

  # - imports python-packages.nix
  # - adds spliced package sets to the package set
  # - applies overrides from `packageOverrides` and `pythonPackagesOverlays`.
  pythonPackages = ensurePythonModules (
    let
      pythonPackagesFun = import ./python-packages-base.nix {
        inherit
          stdenv
          pkgs
          lib
          ;
        python = interpreter;
      };
      otherSplices = {
        selfBuildBuild = pythonOnBuildForBuild.pkgs;
        selfBuildHost = pythonOnBuildForHost.pkgs;
        selfBuildTarget = pythonOnBuildForTarget.pkgs;
        selfHostHost = pythonOnHostForHost.pkgs;
        selfTargetTarget = pythonOnTargetForTarget.pkgs or { }; # There is no Python TargetTarget.
      };
      hooks = import ./hooks/default.nix;
      keep = self: hooks self { };
      optionalExtensions = cond: as: lib.optionals cond as;
      python2Extension = import ../../development/misc/resholve/python2-packages.nix;
      extensions = lib.composeManyExtensions (
        [
          # overlay hooks
          (
            self: super:
            let
              res = hooks self super;
              conflictingAttrs = lib.intersectAttrs res super;
            in
            assert lib.assertMsg (conflictingAttrs == { }) (
              "The following attributes were defined both in `pkgs/sets/${dirname}/hooks/default.nix` and elsewhere, "
              + "most likely in `pkgs/sets/${dirname}/python-packages-base.nix`: "
              + (lib.concatStringsSep ", " (lib.attrNames conflictingAttrs))
            );
            res
          )

          # overlay by-name packages
          (
            self: super:
            let
              res = import ../../top-level/by-name-overlay.nix ./by-name self super;
              conflictingAttrs = lib.intersectAttrs res super;
            in
            assert lib.assertMsg (conflictingAttrs == { }) (
              "The following attributes were defined both in `pkgs/sets/${dirname}/by-name` and elsewhere: "
              + "most likely in `pkgs/sets/${dirname}/python-packages-base.nix` or `pkgs/sets/${dirname}/hooks/default.nix`: "
              + "${lib.concatStringsSep ", " (lib.attrNames conflictingAttrs)}"
            );
            res
          )

          # overlay functions
          (
            self: super:
            let
              res = import ./functions.nix self super;
              conflictingAttrs = lib.intersectAttrs res super;
            in
            assert lib.assertMsg (conflictingAttrs == { }) (
              "The following attributes were defined both in `pkgs/sets/${dirname}/functions.nix` and elsewhere, "
              + "most likely in `pkgs/sets/${dirname}/python-packages-base.nix`, `pkgs/sets/${dirname}/hooks/default.nix` "
              + "or `pkgs/sets/${dirname}/by-name/`: "
              + (lib.concatStringsSep ", " (lib.attrNames conflictingAttrs))
            );
            res
          )

          # overlay manual packages
          (
            self: super:
            let
              res = import ./manual-packages.nix self super;
              conflictingAttrs = lib.intersectAttrs res super;
            in
            assert lib.assertMsg (conflictingAttrs == { }) (
              "The following attributes were defined both in `pkgs/sets/${dirname}/manual-packages.nix` and elsewhere, "
              + "most likely in `pkgs/sets/${dirname}/python-packages-base.nix`, `pkgs/sets/${dirname}/hooks/default.nix`, "
              + "`pkgs/sets/${dirname}/by-name/` or `pkgs/sets/${dirname}/functions.nix`: "
              + (lib.concatStringsSep ", " (lib.attrNames conflictingAttrs))
            );
            res
          )
        ]
        ++ (optionalExtensions (!interpreter.isPy3k) [
          python2Extension
        ])
        ++ pythonPackagesExtensions
        ++ [
          packageOverrides
          # overlay aliases
          (
            self: super:
            let
              res = import ./aliases.nix self super;
              conflictingAttrs = builtins.intersectAttrs res super;
            in
            assert lib.assertMsg (conflictingAttrs == { }) (
              "The following attributes were defined both in `pkgs/sets/${dirname}/aliases.nix` and elsewhere, "
              + "most likely in `pkgs/sets/${dirname}/python-packages-base.nix`, `pkgs/sets/${dirname}/hooks/default.nix`, "
              + "`pkgs/sets/${dirname}/by-name/`, `pkgs/sets/${dirname}/functions.nix` or `pkgs/sets/${dirname}/manual-packages.nix`: "
              + (lib.concatStringsSep ", " (lib.attrNames conflictingAttrs))
            );
            (lib.optionalAttrs config.allowAliases res)
          )
        ]
      );
    in
    makeScopeWithSplicing' {
      inherit otherSplices keep;
      f = lib.extends extensions pythonPackagesFun;
    }
  );
in
pythonPackages
