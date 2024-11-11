{
  lib,
  aiohttp,
  aioresponses,
  buildPythonPackage,
  fetchFromGitHub,
  mashumaro,
  orjson,
  poetry-core,
  pytest-asyncio,
  pytest-cov-stub,
  pytestCheckHook,
  pythonOlder,
  syrupy,
  yarl,
}:

buildPythonPackage rec {
  pname = "spotifyaio";
  version = "0.8.1";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "joostlek";
    repo = "python-spotify";
    rev = "refs/tags/v${version}";
    hash = "sha256-R77bdJidZrsaQZjgCr7OLDab2NpJ10575j8rgmFjn2g=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    aiohttp
    mashumaro
    orjson
    yarl
  ];

  # With 0.6.0 the tests are properly mocked
  doCheck = false;

  nativeCheckInputs = [
    aioresponses
    syrupy
    pytest-asyncio
    pytest-cov-stub
    pytestCheckHook
  ];

  pythonImportsCheck = [ "spotifyaio" ];

  meta = {
    description = "Module for interacting with for Spotify";
    homepage = "https://github.com/joostlek/python-spotify/";
    changelog = "https://github.com/joostlek/python-spotify/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
