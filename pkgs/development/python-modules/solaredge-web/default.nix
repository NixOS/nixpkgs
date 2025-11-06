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
  version = "0.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Solarlibs";
    repo = "solaredge-web";
    tag = "v${version}";
    hash = "sha256-Vf/f5NDmjsKY8F5//8uAk+dJEaku94yjNaD2XyX7Vuk=";
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
