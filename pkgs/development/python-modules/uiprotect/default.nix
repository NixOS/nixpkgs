{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  poetry-core,

  # dependencies
  aiofiles,
  aiohttp,
  aioshutil,
  async-timeout,
  av,
  convertertools,
  dateparser,
  orjson,
  packaging,
  pillow,
  platformdirs,
  propcache,
  pydantic,
  pydantic-extra-types,
  pyjwt,
  rich,
  typer,
  yarl,

  # tests
  aiosqlite,
  asttokens,
  ffmpeg,
  pytest-asyncio,
  pytest-benchmark,
  pytest-cov-stub,
  pytest-timeout,
  pytest-xdist,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "uiprotect";
  version = "10.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "uilibs";
    repo = "uiprotect";
    tag = "v${finalAttrs.version}";
    hash = "sha256-tQeDZMukKg3xL/tGeQ7+Rm3lzNJQEcDkErbLfKnaxN8=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    aiofiles
    aiohttp
    aioshutil
    async-timeout
    av
    convertertools
    dateparser
    orjson
    packaging
    pillow
    platformdirs
    propcache
    pydantic
    pydantic-extra-types
    pyjwt
    rich
    typer
    yarl
  ];

  nativeCheckInputs = [
    aiosqlite
    asttokens
    ffmpeg # Required for command ffprobe
    pytest-asyncio
    pytest-benchmark
    pytest-cov-stub
    pytest-timeout
    pytest-xdist
    pytestCheckHook
  ];

  pytestFlags = [ "--benchmark-disable" ];

  pythonImportsCheck = [ "uiprotect" ];

  meta = {
    description = "Python API for UniFi Protect (Unofficial)";
    homepage = "https://github.com/uilibs/uiprotect";
    changelog = "https://github.com/uilibs/uiprotect/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hexa ];
  };
})
