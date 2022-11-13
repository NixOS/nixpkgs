{ lib
, aiohttp
, buildPythonPackage
, fetchPypi
, hatchling
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "tplink-omada-client";
  version = "1.0.1";
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    pname = "tplink_omada_client";
    inherit version;
    hash = "sha256-72Oxrjn1KNasdW9XITuqM5L59/5/R/BvM175d18eFmI=";
  };

  nativeBuildInputs = [
    hatchling
  ];

  propagatedBuildInputs = [
    aiohttp
  ];

  # Module have no tests
  doCheck = false;

  pythonImportsCheck = [
    "tplink_omada_client"
  ];

  meta = with lib; {
    description = "Library for the TP-Link Omada SDN Controller API";
    homepage = "https://github.com/MarkGodwin/tplink-omada-api";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
