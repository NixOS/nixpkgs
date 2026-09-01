{
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  pytest-asyncio,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "solaredge-web";
  version = "0.3.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Solarlibs";
    repo = "solaredge-web";
    tag = "v${version}";
    hash = "sha256-nhsY1/9ohT4CNLbDymNxSHex9AgeyZg+/Qka+L7vF3U=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
  ];

  pythonImportsCheck = [ "solaredge_web" ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  meta = {
    changelog = "https://github.com/Solarlibs/solaredge-web/releases/tag/${src.tag}";
    description = "Library for fetching SolarEdge energy data for each inverter/string/module via the web API";
    homepage = "https://github.com/Solarlibs/solaredge-web";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.dotlambda ];
  };
}
