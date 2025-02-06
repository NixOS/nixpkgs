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
  version = "2025.1.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-XNuwkHwgvhvgZsbi3GnGRYQtEROk6D5kIGVgSiHyVLo=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  pytestFlagsArray = [
    # requires network connections
    "-m 'not request'"
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
    maintainers = lib.teams.geospatial.members;
  };
}
