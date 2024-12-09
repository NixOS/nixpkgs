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
  version = "1.4.3";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    pname = "tplink_omada_client";
    inherit version;
    hash = "sha256-REzjeZs2Ddhw2TLD4Vp75XT2iLaxxzDK/F3UmrC1deo=";
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
