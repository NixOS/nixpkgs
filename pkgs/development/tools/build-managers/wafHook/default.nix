{ lib, stdenv, pkgs, python, makeSetupHook, waf }:

makeSetupHook {
  deps = [ python ];
  substitutions = {
    inherit waf;
    crossFlags = lib.optionalString (stdenv.hostPlatform.system != stdenv.targetPlatform.system)
      ''--cross-compile "--cross-execute=${stdenv.targetPlatform.emulator pkgs}"'';
  };
} ./setup-hook.sh
