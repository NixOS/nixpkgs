{ lib, stdenv, pkgs, makeSetupHook, waf }:

makeSetupHook {
  name = "waf-hook";
  substitutions = {
    inherit waf;
    crossFlags = lib.optionalString (stdenv.hostPlatform.system != stdenv.targetPlatform.system)
      ''--cross-compile "--cross-execute=${lib.systems.emulator stdenv.targetPlatform pkgs}"'';
  };
} ./setup-hook.sh
