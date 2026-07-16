{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  aiohttp,
  hatchling,
  pytz,
  pytestCheckHook,
  pytest-asyncio,
}:

buildPythonPackage rec {
  pname = "tessie-api";
  version = "0.1.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "andrewgierens";
    repo = "tessie_python_api";
    tag = version;
    hash = "sha256-Ia5J7dGbcfEa6rEKyJzEnzVnMC3HyI7l5g20v7d7Gjo=";
  };

  build-system = [ hatchling ];

  dependencies = [
    aiohttp
    pytz
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
  ];

  pythonImportsCheck = [ "tessie_api" ];

  # Tests require API credentials
  doCheck = false;

  meta = {
    description = "Python wrapper for the Tessie API";
    homepage = "https://github.com/andrewgierens/tessie_python_api";
    changelog = "https://github.com/andrewgierens/tessie_python_api/releases/tag/${version}";
    license = lib.licenses.gpl3Plus;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
}
