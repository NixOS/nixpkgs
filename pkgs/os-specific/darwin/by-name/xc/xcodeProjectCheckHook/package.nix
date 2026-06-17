{ makeSetupHook, pkgsBuildHost }:

makeSetupHook {
  name = "xcode-project-check-hook";
  propagatedBuildInputs = [ pkgsBuildHost.openssl ];
} ./setup-hook.sh
