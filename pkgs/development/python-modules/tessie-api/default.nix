{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  aiohttp,
  pythonOlder,
  hatchling,
  pytz,
  pytestCheckHook,
  pytest-asyncio,
}:

buildPythonPackage rec {
  pname = "tessie-api";
  version = "0.1.2";
  pyproject = true;

  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "andrewgierens";
    repo = "tessie_python_api";
    tag = version;
    hash = "sha256-uY52SSG2u4lcX9X7Ql/pn31uOwpqIy3kkuLMvsFBA3s=";
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
