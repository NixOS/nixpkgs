{ python
, callPackage
, makeSetupHook
, yj
}:

let
  pythonInterpreter = python.pythonForBuild.interpreter;
in
{

  removePathDependenciesHook = callPackage (
    {}:
      makeSetupHook {
        name = "remove-path-dependencies.sh";
        deps = [];
        substitutions = {
          inherit pythonInterpreter;
          yj = "${yj}/bin/yj";
          pyprojectPatchScript = "${./pyproject-without-path.py}";
        };
      } ./remove-path-dependencies.sh
  ) {};

  poetry2nixFixupHook = callPackage (
    {}:
      makeSetupHook {
        name = "fixup-hook.sh";
        deps = [];
      } ./fixup-hook.sh
  ) {};

}
