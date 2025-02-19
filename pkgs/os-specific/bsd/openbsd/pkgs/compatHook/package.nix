{
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
} ./setup-hook.sh
