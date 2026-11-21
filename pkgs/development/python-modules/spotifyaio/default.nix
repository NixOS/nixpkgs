{
  lib,
  aiohttp,
  aiointercept,
  buildPythonPackage,
  fetchFromGitHub,
  mashumaro,
  orjson,
  poetry-core,
  pytest-asyncio,
  pytest-cov-stub,
  pytestCheckHook,
  syrupy,
  yarl,
}:

buildPythonPackage rec {
  pname = "spotifyaio";
  version = "2.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "joostlek";
    repo = "python-spotify";
    tag = "v${version}";
    hash = "sha256-bBEhElQO36jDsEt12MI7hfhSV5zCuavkPwB3TcTTqfI=";
  };

  postPatch = ''
    # Version is wrong and not properly set by upstream's workflow
    substituteInPlace pyproject.toml \
      --replace-fail 'version = "0.2.0"' 'version = "${version}"'
  '';

  build-system = [ poetry-core ];

  dependencies = [
    aiohttp
    mashumaro
    orjson
    yarl
  ];

  nativeCheckInputs = [
    aiointercept
    syrupy
    pytest-asyncio
    pytest-cov-stub
    pytestCheckHook
  ];

  pythonImportsCheck = [ "spotifyaio" ];

  meta = {
    description = "Module for interacting with for Spotify";
    homepage = "https://github.com/joostlek/python-spotify/";
    changelog = "https://github.com/joostlek/python-spotify/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
