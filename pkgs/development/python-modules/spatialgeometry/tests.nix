{
  buildPythonPackage,
  spatialgeometry,
  roboticstoolbox-python,
  pybullet,
  pytestCheckHook,
}:
buildPythonPackage {
  pname = "spatialgeometry-tests";
  inherit (spatialgeometry) version;

  src = spatialgeometry.testsout;

  format = "other";
  dontBuild = true;
  dontInstall = true;

  nativeCheckInputs = [
    pytestCheckHook
    spatialgeometry
    roboticstoolbox-python
    pybullet
  ];
}
