{
  lib,
  aiohttp,
  aioresponses,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pyroute2,
  pytest-asyncio,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "unifi-discovery";
  version = "1.2.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "bdraco";
    repo = "unifi-discovery";
    rev = "refs/tags/v${version}";
    hash = "sha256-Ea+zxV2GUAaG/BxO103NhOLzzr/TNJaOsynDad2/2VA=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "--cov=unifi_discovery --cov-report=term-missing:skip-covered" ""
  '';

  build-system = [ poetry-core ];

  dependencies = [
    aiohttp
    pyroute2
  ];

  nativeCheckInputs = [
    aioresponses
    pytest-asyncio
    pytestCheckHook
  ];

  pytestFlagsArray = [ "--asyncio-mode=auto" ];

  pythonImportsCheck = [ "unifi_discovery" ];

  meta = with lib; {
    description = "Module to discover Unifi devices";
    homepage = "https://github.com/bdraco/unifi-discovery";
    changelog = "https://github.com/bdraco/unifi-discovery/releases/tag/v${version}";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
    platforms = platforms.linux;
  };
}
