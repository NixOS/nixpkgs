{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,

  # build-system
  poetry-core,

  # dependencies
  aiofiles,
  aiohttp,
  aioshutil,
  async-timeout,
  convertertools,
  dateparser,
  orjson,
  packaging,
  pillow,
  platformdirs,
  propcache,
  pydantic,
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

buildPythonPackage rec {
  pname = "uiprotect";
  version = "6.4.0";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "uilibs";
    repo = "uiprotect";
    rev = "refs/tags/v${version}";
    hash = "sha256-+BHxcwQhx4lOqS0ATk1PjLbyTu7xQakM3HMrydXeGUc=";
  };

  build-system = [ poetry-core ];

  pythonRelaxDeps = [
    "aiofiles"
    "pydantic"
  ];

  dependencies = [
    aiofiles
    aiohttp
    aioshutil
    async-timeout
    convertertools
    dateparser
    orjson
    packaging
    pillow
    platformdirs
    propcache
    pydantic
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

  pytestFlagsArray = [ "--benchmark-disable" ];

  disabledTests = [
    # https://127.0.0.1 vs https://127.0.0.1:0
    "test_base_url"
    "test_bootstrap"
  ];

  pythonImportsCheck = [ "uiprotect" ];

  meta = with lib; {
    description = "Python API for UniFi Protect (Unofficial)";
    homepage = "https://github.com/uilibs/uiprotect";
    changelog = "https://github.com/uilibs/uiprotect/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
