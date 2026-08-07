{
  lib,
  python3Packages,
  makeSetupHook,
}:

makeSetupHook {
  name = "manifest-check-hook";
  substitutions = {
    pythonCheckInterpreter = python3Packages.python.interpreter;
    checkManifest = ./check_manifest.py;
  };
  meta.license = lib.licenses.mit;
} ./manifest-requirements-check-hook.sh
