{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
<<<<<<< HEAD
=======
  pythonOlder,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

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

buildPythonPackage rec {
  pname = "uiprotect";
<<<<<<< HEAD
  version = "7.33.3";
  pyproject = true;

=======
  version = "7.23.0";
  pyproject = true;

  disabled = pythonOlder "3.10";

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  src = fetchFromGitHub {
    owner = "uilibs";
    repo = "uiprotect";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-sVWgomaCrfZSlJpoLfYLkZXgJE0dw8ki8+VTbhkoDaE=";
=======
    hash = "sha256-UScv0RAIgkFYl3yJZDuSzXXV3iI/3maV42hN4EtfUio=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

<<<<<<< HEAD
  pythonImportsCheck = [ "uiprotect" ];

  meta = {
    description = "Python API for UniFi Protect (Unofficial)";
    homepage = "https://github.com/uilibs/uiprotect";
    changelog = "https://github.com/uilibs/uiprotect/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hexa ];
=======
  disabledTests = [
    # https://127.0.0.1 vs https://127.0.0.1:0
    "test_base_url"
    "test_bootstrap"
  ];

  disabledTestPaths = [
    # hangs the test suite
    "tests/test_api_ws.py"
  ];

  pythonImportsCheck = [ "uiprotect" ];

  meta = with lib; {
    description = "Python API for UniFi Protect (Unofficial)";
    homepage = "https://github.com/uilibs/uiprotect";
    changelog = "https://github.com/uilibs/uiprotect/blob/${src.tag}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
