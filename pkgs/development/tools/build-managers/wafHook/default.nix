{ lib, stdenv, pkgs, python3, makeSetupHook, waf }:

makeSetupHook {
  deps = [ python3 ];
  substitutions = {
    inherit waf;
    crossFlags = lib.optionalString (stdenv.hostPlatform.system != stdenv.targetPlatform.system)
      ''--cross-compile "--cross-execute=${stdenv.targetPlatform.emulator pkgs}"'';
  };
} ./setup-hook.sh
