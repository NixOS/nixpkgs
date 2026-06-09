{
  lib,
  stdenv,
  makeSetupHook,
  compat,
}:

makeSetupHook {
  name = "openbsd-compat-hook";
  substitutions = {
    inherit compat;
    inherit (stdenv.cc) suffixSalt;
  };
  meta.license = lib.licenses.mit;
} ./setup-hook.sh
