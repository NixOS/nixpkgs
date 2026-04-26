{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  hatchling,
  trame-client,
}:

buildPythonPackage (finalAttrs: {
  name = "trame-vtk";
  version = "2.11.8";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Kitware";
    repo = "trame-vtk";
    tag = "v${finalAttrs.version}";
    hash = "sha256-cNBHQS1nakRnFDbFLMwVEUzQj4zipY/z/5awuObMJJM=";
  };

  pyproject = true;
  build-system = [
    hatchling
  ];
  propagatedBuildInputs = [
    trame-client
  ];

  pythonImportsCheck = [
    "trame_vtk.modules"
    "trame_vtk.tools"
    "trame_vtk.widgets"
    "trame.modules"
    "trame.tools"
    "trame.widgets"
  ];

  meta = {
    description = "VTK/ParaView widgets for trame";
    homepage = "https://github.com/kitware/trame-vtk";
    maintainers = with lib.maintainers; [ BrockoliniMorgan ];
    license = lib.licenses.bsd3;
  };
})
