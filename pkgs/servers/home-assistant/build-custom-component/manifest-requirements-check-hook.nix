{
  python3Packages,
  makeSetupHook,
}:

makeSetupHook {
  name = "manifest-check-hook";
  substitutions = {
    pythonCheckInterpreter = python3Packages.python.interpreter;
    checkManifest = ./check_manifest.py;
  };
} ./manifest-requirements-check-hook.sh
