{
  lib,
  makeSetupHook,
  pkgsBuildHost,
}:

makeSetupHook {
  name = "xcode-project-check-hook";
  propagatedBuildInputs = [ pkgsBuildHost.openssl ];
  meta.license = lib.licenses.mit;
} ./setup-hook.sh
