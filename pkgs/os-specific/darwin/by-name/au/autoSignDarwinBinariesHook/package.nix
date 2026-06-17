{ signingUtils, makeSetupHook }:

makeSetupHook {
  name = "auto-sign-darwin-binaries-hook";
  propagatedBuildInputs = [ signingUtils ];
} ./auto-sign-hook.sh
