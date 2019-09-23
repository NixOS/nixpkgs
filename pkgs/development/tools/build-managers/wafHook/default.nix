{ lib, stdenv, pkgs, python3, makeSetupHook, waf }:

makeSetupHook {
  substitutions = {
    inherit waf;
    python = python3;
    crossFlags = lib.optionalString (stdenv.hostPlatform.system != stdenv.targetPlatform.system)
      ''--cross-compile "--cross-execute=${stdenv.targetPlatform.emulator pkgs}"'';
  };
} ./setup-hook.sh
