{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchPypi
, mercantile
, pytestCheckHook
, requests
}:

buildPythonPackage rec {
  pname = "xyzservices";
  version = "2023.2.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-M0K7pBDXlBKQ7tDlii5arbD3uXhj7EKDsoPEBu5yOig=";
  };

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
