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
  version = "2025.11.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-L8crSVArJQI/1x6PUy+0vt278KoSTZDqJdukT1ReF84=";
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
