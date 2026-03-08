{
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "solaredge-web";
  version = "0.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Solarlibs";
    repo = "solaredge-web";
    tag = "v${version}";
    hash = "sha256-bONCD7dE8U0Y55UuQ0VYQE5r/q7ihtki33ZkPssiIJ4=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
  ];

  pythonImportsCheck = [ "solaredge_web" ];

  nativeCheckInputs = [
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
