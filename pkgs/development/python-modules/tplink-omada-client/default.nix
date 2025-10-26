{
  lib,
  aiohttp,
  awesomeversion,
  buildPythonPackage,
  fetchPypi,
  hatchling,
}:

buildPythonPackage (finalAttrs: {
  pname = "tplink-omada-client";
  version = "1.5.5";
  pyproject = true;

  src = fetchPypi {
    pname = "tplink_omada_client";
    inherit (finalAttrs) version;
    hash = "sha256-uefZ1MIt0xuLo1JZEYIJhrwY4V8KG0Rb16+ZY7PwEwI=";
  };

  build-system = [ hatchling ];

  dependencies = [
    aiohttp
    awesomeversion
  ];

  # Module have no tests
  doCheck = false;

  pythonImportsCheck = [ "tplink_omada_client" ];

  meta = {
    description = "Library for the TP-Link Omada SDN Controller API";
    homepage = "https://github.com/MarkGodwin/tplink-omada-api";
    changelog = "https://github.com/MarkGodwin/tplink-omada-api/releases/tag/release%2Fv${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "omada";
  };
})
