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
  pythonOlder,
  requests,
  rich,
}:

buildPythonPackage rec {
  pname = "surepy";
  version = "0.9.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "benleb";
    repo = "surepy";
    tag = "v${version}";
    hash = "sha256-ETgpXSUUsV1xoZjdnL2bzn4HwDjKC2t13yXwf28OBqI=";
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

  meta = with lib; {
    description = "Python library to interact with the Sure Petcare API";
    homepage = "https://github.com/benleb/surepy";
    changelog = "https://github.com/benleb/surepy/releases/tag/v${src.tag}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
    mainProgram = "surepy";
  };
}
