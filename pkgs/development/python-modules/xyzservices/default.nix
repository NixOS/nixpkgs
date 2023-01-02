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
  version = "2022.9.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-VWUZYXCLmhSEmXizOd92AIyIbfeoMmMIpVSbrlUWJgw=";
  };

  pythonImportsCheck = [
    "xyzservices.providers"
  ];

  checkInputs = [
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
