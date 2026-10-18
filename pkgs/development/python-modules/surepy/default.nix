{
  lib,
  aiodns,
  aiohttp,
  async-timeout,
  attrs,
  brotlipy,
  buildPythonPackage,
  faust-cchardet,
  click,
  colorama,
  fetchFromGitHub,
  halo,
  poetry-core,
  requests,
  rich,
}:

buildPythonPackage rec {
  pname = "surepy";
  version = "0.10.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "benleb";
    repo = "surepy";
    tag = "v${version}";
    hash = "sha256-b93SqZr+9VKYHoFxkutZ01LsuvtGiDO5FrHIrZvho94=";
  };

  pythonRelaxDeps = [
    "aiohttp"
    "async-timeout"
    "rich"
  ];

  build-system = [ poetry-core ];

  dependencies = [
    aiodns
    aiohttp
    async-timeout
    attrs
    brotlipy
    click
    colorama
    faust-cchardet
    halo
    requests
    rich
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "surepy" ];

  meta = {
    description = "Python library to interact with the Sure Petcare API";
    homepage = "https://github.com/benleb/surepy";
    changelog = "https://github.com/benleb/surepy/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "surepy";
  };
}
