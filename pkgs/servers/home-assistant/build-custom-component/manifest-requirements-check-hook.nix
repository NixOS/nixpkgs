{
  python,
  makeSetupHook,
}:

makeSetupHook {
  name = "manifest-requirements-check-hook";
  substitutions = {
    pythonCheckInterpreter = python.interpreter;
    checkManifest = ./check_manifest.py;
  };
} ./manifest-requirements-check-hook.sh
