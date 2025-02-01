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
  version = "2024.4.0";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-agTxFIem+3fZKpiYTNEH+9kVf9XmX5Ka3Zw9bmBO6Iw=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  disabledTests = [
    # requires network connections
    "test_free_providers"
  ];

  pythonImportsCheck = [ "xyzservices.providers" ];

  nativeCheckInputs = [
    mercantile
    pytestCheckHook
    requests
  ];

  meta = with lib; {
    changelog = "https://github.com/geopandas/xyzservices/releases/tag/${version}";
    description = "Source of XYZ tiles providers";
    homepage = "https://github.com/geopandas/xyzservices";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
