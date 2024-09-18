{
  lib,
  aiohttp,
  awesomeversion,
  buildPythonPackage,
  fetchPypi,
  hatchling,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "tplink-omada-client";
  version = "1.4.2";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    pname = "tplink_omada_client";
    inherit version;
    hash = "sha256-Dt1F7mCuRrzEk3NDVfxScSLrK0omHQFMWhYrrwc+Pq0=";
  };

  build-system = [ hatchling ];

  dependencies = [
    aiohttp
    awesomeversion
  ];

  # Module have no tests
  doCheck = false;

  pythonImportsCheck = [ "tplink_omada_client" ];

  meta = with lib; {
    description = "Library for the TP-Link Omada SDN Controller API";
    homepage = "https://github.com/MarkGodwin/tplink-omada-api";
    changelog = "https://github.com/MarkGodwin/tplink-omada-api/releases/tag/release%2Fv${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
    mainProgram = "omada";
  };
}
