{
  lib,
  python,
  makeSetupHook,
}:

makeSetupHook {
  name = "manifest-check-hook";
  substitutions = {
    pythonCheckInterpreter = python.interpreter;
    checkManifest = ./check_manifest.py;
  };
  meta.license = lib.licenses.mit;
} ./manifest-requirements-check-hook.sh
