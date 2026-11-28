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
  orjson,
  packaging,
  pillow,
  platformdirs,
  propcache,
  pydantic,
  rich,
  typer,
  yarl,

  # tests
  ffmpeg,
  jsonschema,
  pytest-asyncio,
  pytest-benchmark,
  pytest-cov-stub,
  pytest-timeout,
  pytest-xdist,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "uiprotect";
  version = "25.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "uilibs";
    repo = "uiprotect";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2WRAVqhkAw5uX+icjT9fOD0hFe/zEjomk7qZmdXiKDY=";
  };

  build-system = [ poetry-core ];

  pythonRelaxDeps = [
    "orjson"
    "packaging"
    "platformdirs"
    "propcache"
    "pydantic"
    "pyjwt"
    "rich"
    "typer"
  ];

  dependencies = [
    aiofiles
    aiohttp
    av
    convertertools
    orjson
    packaging
    pillow
    platformdirs
    propcache
    pydantic
    rich
    typer
    yarl
  ];

  nativeCheckInputs = [
    ffmpeg # Required for command ffprobe
    jsonschema
    pytest-asyncio
    pytest-benchmark
    pytest-cov-stub
    pytest-timeout
    pytest-xdist
    pytestCheckHook
  ];

  pytestFlags = [ "--benchmark-disable" ];

  disabledTests = [
    # not useful in nix packaging
    "test_import_skips_optional_test_util_dependencies"
  ];

  pythonImportsCheck = [ "uiprotect" ];

  meta = {
    description = "Python API for UniFi Protect (Unofficial)";
    homepage = "https://github.com/uilibs/uiprotect";
    changelog = "https://github.com/uilibs/uiprotect/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hexa ];
  };
})
