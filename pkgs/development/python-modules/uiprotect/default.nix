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
  dateparser,
  orjson,
  packaging,
  pillow,
  platformdirs,
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
  pytest-timeout,
  pytest-xdist,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "uiprotect";
  version = "1.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "uilibs";
    repo = "uiprotect";
    rev = "refs/tags/v${version}";
    hash = "sha256-TWErGEQot99x48Ti9rBxaq9qcrZiT/W0irdR+UxC1XI=";
  };

  postPatch = ''
    sed -i "/addopts =/d" pyproject.toml
  '';

  build-system = [ poetry-core ];

  dependencies = [
    aiofiles
    aiohttp
    aioshutil
    async-timeout
    dateparser
    orjson
    packaging
    pillow
    platformdirs
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
    pytest-timeout
    pytest-xdist
    pytestCheckHook
  ];

  pytestFlagsArray = [ "--benchmark-disable" ];

  pythonImportsCheck = [ "uiprotect" ];

  meta = with lib; {
    description = "Python API for UniFi Protect (Unofficial";
    homepage = "https://github.com/uilibs/uiprotect";
    changelog = "https://github.com/uilibs/uiprotect/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
