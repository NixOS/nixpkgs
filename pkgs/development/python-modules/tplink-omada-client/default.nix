{ lib
, aiohttp
, awesomeversion
, buildPythonPackage
, fetchPypi
, hatchling
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "tplink-omada-client";
  version = "1.3.5";
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    pname = "tplink_omada_client";
    inherit version;
    hash = "sha256-tCyYaYJIkuJBGgE3xxc/jMir1mc7UDRXZ3i1Ai1/mxs=";
  };

  nativeBuildInputs = [
    hatchling
  ];

  propagatedBuildInputs = [
    aiohttp
    awesomeversion
  ];

  # Module have no tests
  doCheck = false;

  pythonImportsCheck = [
    "tplink_omada_client"
  ];

  meta = with lib; {
    description = "Library for the TP-Link Omada SDN Controller API";
    homepage = "https://github.com/MarkGodwin/tplink-omada-api";
    changelog = "https://github.com/MarkGodwin/tplink-omada-api/releases/tag/release%2Fv${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
