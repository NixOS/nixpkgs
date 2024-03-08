{ lib
, buildPythonPackage
, fetchPypi
, mercantile
, pytestCheckHook
, requests
, setuptools
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "xyzservices";
  version = "2023.10.1";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-CRIpJpBDvIJYBC7b7a1Py0RoSwRz7eAntWcq1A3J+gI=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  disabledTests = [
    # requires network connections
    "test_free_providers"
  ];

  pythonImportsCheck = [
    "xyzservices.providers"
  ];

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
