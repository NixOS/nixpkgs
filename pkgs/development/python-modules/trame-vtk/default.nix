{
  lib,
  buildPythonPackage,
  fetchPypi,
  nix-update-script,

  # build-system
  hatchling,

  # dependencies
  trame-client,
  vtk,
}:
buildPythonPackage (finalAttrs: {
  pname = "trame-vtk";
  version = "2.11.15";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchPypi {
    inherit (finalAttrs) version;
    pname = "trame_vtk";
    hash = "sha256-s1OG+FM0Y8J/otsZYW04q4yyjMhVATNgwfCMLTFOpxs=";
  };

  build-system = [ hatchling ];

  propagatedBuildInputs = [
    trame-client
    vtk
  ];

  postPatch = ''
    # Ensure PEP 420 namespace package layout (split across trame-* packages)
    find src/trame -type f -name '__init__.py' -delete
  '';

  pythonImportsCheck = [
    "trame_vtk"
    "trame_vtk.modules"
    "trame_vtk.tools"
    "trame_vtk.widgets"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "VTK widgets for trame";
    homepage = "https://github.com/Kitware/trame-vtk";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ cjshearer ];
  };
})
