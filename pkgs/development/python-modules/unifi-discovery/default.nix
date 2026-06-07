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

buildPythonPackage (finalAttrs: {
  pname = "unifi-discovery";
  version = "1.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bdraco";
    repo = "unifi-discovery";
    tag = "v${finalAttrs.version}";
    hash = "sha256-pn8WRsYGbBy4EwQ1DufY2WbbVM65dM4h8ZReG+qkr6k=";
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
    changelog = "https://github.com/bdraco/unifi-discovery/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
    platforms = lib.platforms.linux;
  };
})
