{
  lib,
  signingUtils,
  makeSetupHook,
}:

makeSetupHook {
  name = "auto-sign-darwin-binaries-hook";
  propagatedBuildInputs = [ signingUtils ];
  meta.license = lib.licenses.mit;
} ./auto-sign-hook.sh
