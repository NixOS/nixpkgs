{
  lib,
  buildPythonPackage,
  fetchPypi,
  mercantile,
  pytestCheckHook,
  requests,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "xyzservices";
  version = "2026.9.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-jRo5v2sZKUDMXbUmTu78GyDdGE+Lg7EwOweHQ3RPWUM=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  disabledTestMarks = [
    # requires network connections
    "request"
  ];

  pythonImportsCheck = [ "xyzservices.providers" ];

  nativeCheckInputs = [
    mercantile
    pytestCheckHook
    requests
  ];

  meta = {
    changelog = "https://github.com/geopandas/xyzservices/releases/tag/${version}";
    description = "Source of XYZ tiles providers";
    homepage = "https://github.com/geopandas/xyzservices";
    license = lib.licenses.bsd3;
    teams = [ lib.teams.geospatial ];
  };
}
