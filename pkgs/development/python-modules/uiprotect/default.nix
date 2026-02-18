{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  poetry-core,

  # dependencies
  aiofiles,
  aiohttp,
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
  version = "10.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "uilibs";
    repo = "uiprotect";
    tag = "v${finalAttrs.version}";
    hash = "sha256-4zgE5XbjCZzu+Ug66cgKy/Zqy1oyTDIVsPpyDrcra24=";
  };

  build-system = [ poetry-core ];

  pythonRemoveDeps = [
    "aioshutil"
    "async-timeout"
  ];

  dependencies = [
    aiofiles
    aiohttp
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
