{ python
, callPackage
, makeSetupHook
, yj
, wheel
, pip
}:
let
  pythonInterpreter = python.pythonForBuild.interpreter;
  pythonSitePackages = python.sitePackages;
in
{

  removePathDependenciesHook = callPackage
    (
      {}:
      makeSetupHook
        {
          name = "remove-path-dependencies.sh";
          deps = [ ];
          substitutions = {
            inherit pythonInterpreter;
            yj = "${yj}/bin/yj";
            pyprojectPatchScript = "${./pyproject-without-path.py}";
          };
        } ./remove-path-dependencies.sh
    ) { };

  pipBuildHook = callPackage
    (
      { pip, wheel }:
      makeSetupHook
        {
          name = "pip-build-hook.sh";
          deps = [ pip wheel ];
          substitutions = {
            inherit pythonInterpreter pythonSitePackages;
          };
        } ./pip-build-hook.sh
    ) { };

  poetry2nixFixupHook = callPackage
    (
      {}:
      makeSetupHook
        {
          name = "fixup-hook.sh";
          deps = [ ];
        } ./fixup-hook.sh
    ) { };

}
