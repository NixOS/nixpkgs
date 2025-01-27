{
  python,
  makeSetupHook,
}:

makeSetupHook {
  name = "manifest-check-hook";
  substitutions = {
    pythonCheckInterpreter = python.interpreter;
    checkManifest = ./check_manifest.py;
  };
} ./manifest-requirements-check-hook.sh
