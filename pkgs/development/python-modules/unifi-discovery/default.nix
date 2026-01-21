{
  lib,
  aiohttp,
  aioresponses,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pyroute2,
  pytest-asyncio,
  pytest-cov-stub,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "unifi-discovery";
  version = "1.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bdraco";
    repo = "unifi-discovery";
    tag = "v${version}";
    hash = "sha256-Ea+zxV2GUAaG/BxO103NhOLzzr/TNJaOsynDad2/2VA=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    aiohttp
    pyroute2
  ];

  nativeCheckInputs = [
    aioresponses
    pytest-asyncio
    pytest-cov-stub
    pytestCheckHook
  ];

  pytestFlags = [ "--asyncio-mode=auto" ];

  pythonImportsCheck = [ "unifi_discovery" ];

  meta = {
    description = "Module to discover Unifi devices";
    homepage = "https://github.com/bdraco/unifi-discovery";
    changelog = "https://github.com/bdraco/unifi-discovery/releases/tag/v${version}";
    license = with lib.licenses; [ asl20 ];
    maintainers = with lib.maintainers; [ fab ];
    platforms = lib.platforms.linux;
  };
}
