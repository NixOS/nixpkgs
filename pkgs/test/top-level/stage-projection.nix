{
  lib,
  pkgs,
  nixpkgsFun,
}:
let
  extendAt = stage: overlay: stage.__stage.select (stage.__stage.extendGraph overlay);
  original = nixpkgsFun {
    localSystem = {
      system = "x86_64-linux";
    };
    crossSystem = {
      system = "aarch64-linux";
    };
    config =
      { pkgs, ... }:
      {
        packageOverrides = _: { configStageTrace = pkgs.stageTrace; };
      };
    overlays = [
      (final: _: {
        stageTrace = [ ];
        variantValue = "original";
        transitiveValue = final.variantValue;
      })
    ];
    crossOverlays = [ (_: prev: { stageTrace = prev.stageTrace ++ [ "HOST" ]; }) ];
  };
  build = original.pkgsBuildHost;
  extended = extendAt build (_: _: { variantValue = "extended"; });
  repeated = extendAt extended (_: _: { secondValue = true; });
  laterCross = extended.pkgsCross.riscv64;
  ordinary = extended.extend (_: _: { ordinaryValue = true; });
  samePlatforms =
    left: right:
    lib.all (role: lib.systems.equals left.stdenv.${role} right.stdenv.${role}) [
      "buildPlatform"
      "hostPlatform"
      "targetPlatform"
    ];
  native = nixpkgsFun {
    localSystem = {
      system = "x86_64-linux";
    };
  };
  nativeWithCrossOverlay = nixpkgsFun {
    localSystem.system = "x86_64-linux";
    crossOverlays = [ (_: _: { runStageOnly = true; }) ];
  };
  nativeSelections =
    p:
    map (name: p.${name}.drvPath) [
      "stdenv"
      "stdenvNoCC"
      "hello"
      "libc"
      "libiconv"
      "libidn2"
    ];
  nativeWithInputs = nixpkgsFun {
    localSystem.system = "x86_64-linux";
    crossOverlays = [ (_: _: { }) ];
    stdenvStages =
      args:
      let
        stages = import ../../stdenv args;
      in
      lib.imap0 (
        index: makeStage: previous:
        let
          stage = makeStage previous;
        in
        if index == builtins.length stages - 3 then
          stage
          // {
            stdenv = stage.stdenv.override { extraBuildInputs = [ previous.zlib ]; };
          }
        else
          stage
      ) stages;
  };
  nativeReplaced = nixpkgsFun {
    localSystem.system = "x86_64-linux";
    crossOverlays = [ (_: _: { }) ];
    config.replaceCrossStdenv = { baseStdenv, ... }: baseStdenv // { replacedCross = true; };
  };
  sameSystemCompilers =
    map
      (
        compiler:
        nixpkgsFun {
          localSystem.system = "x86_64-linux";
          crossSystem = {
            system = "x86_64-linux";
            ${compiler} = true;
          };
        }
      )
      [
        "useLLVM"
        "useGccNG"
      ];
  filtered = nixpkgsFun {
    localSystem = {
      system = "x86_64-linux";
    };
    crossSystem = {
      system = "aarch64-linux";
    };
    config.attrPathsDisallowedForInternalUse = [
      {
        attrPath = [ "hello" ];
        reason = "stage-selection regression";
      }
    ];
  };
  changingLayout = nixpkgsFun {
    localSystem.system = "x86_64-linux";
    crossSystem.system = "aarch64-linux";
    stdenvStages =
      args:
      import ../../stdenv args
      ++ lib.optional (args.overlays != [ ]) (prev: {
        inherit (args) config overlays;
        stdenv = prev.stdenv;
      });
  };
  custom = nixpkgsFun {
    localSystem = {
      system = "x86_64-linux";
    };
    config.replaceStdenv =
      { pkgs }:
      pkgs.stdenv
      // {
        customStage = true;
        previous = extendAt pkgs (_: _: { previousExtended = true; });
      };
  };
in
# A stage-only overlay retains native bootstrap libraries and selected inputs.
assert nativeSelections nativeWithCrossOverlay == nativeSelections native;
assert samePlatforms nativeWithCrossOverlay native;
assert nativeWithCrossOverlay.runStageOnly;
assert !(nativeWithCrossOverlay.pkgsBuildHost ? runStageOnly);
assert nativeWithInputs.stdenv.extraBuildInputs != [ ];
assert
  map (x: x.drvPath) nativeWithInputs.stdenv.extraBuildInputs
  == map (x: x.drvPath) nativeWithInputs.pkgsBuildHost.stdenv.extraBuildInputs;
assert nativeReplaced.stdenv.replacedCross;
# Equal CPU/kernel names do not erase explicit compiler selection.
assert lib.all (
  p: !(lib.systems.equals p.stdenv.buildPlatform p.stdenv.hostPlatform)
) sameSystemCompilers;
assert (builtins.elemAt sameSystemCompilers 0).stdenv.cc.isClang;
assert
  (builtins.elemAt sameSystemCompilers 1).stdenv.cc.drvPath == (builtins.elemAt sameSystemCompilers 1)
  .buildPackages.gccNGPackages.gcc.drvPath;
assert !(builtins.tryEval (extendAt changingLayout.pkgsBuildHost (_: _: { }))).success;
# A projected view retains the original graph, including later stages.
assert samePlatforms (builtins.head extended.__stage.stages) original;
assert (builtins.head extended.__stage.stages).variantValue == "extended";
assert custom.stdenv.previous.previousExtended;
assert !(custom.stdenv.previous.stdenv.customStage or false);
assert samePlatforms extended build;
assert samePlatforms repeated build;
assert repeated.secondValue;
assert extended.transitiveValue == "extended";
assert extended.stageTrace == [ ];
# Returning BUILD must not change the final-stage package set seen by config.
assert extended.configStageTrace == build.configStageTrace;
assert extended.configStageTrace == [ "HOST" ];
assert extended.pkgsTargetTarget.stageTrace == [ "HOST" ];
assert extended.pkgsTargetTarget.variantValue == "extended";
# Stage selection is per operation: ordinary variants still return their final stage.
assert samePlatforms ordinary original;
assert ordinary.ordinaryValue;
assert laterCross.stdenv.hostPlatform.system == "riscv64-linux";
assert laterCross.stdenv.targetPlatform.system == "riscv64-linux";
assert laterCross.transitiveValue == "extended";
assert samePlatforms extended.pkgsStatic build.pkgsStatic;
assert samePlatforms (extendAt native (_: _: { })) native;
assert (extendAt custom (_: _: { })).stdenv.customStage;
assert !(filtered ? hello);
assert !((extendAt filtered.pkgsBuildHost (_: _: { })) ? hello);
pkgs.emptyFile
