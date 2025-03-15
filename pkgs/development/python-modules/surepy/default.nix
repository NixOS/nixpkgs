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
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "benleb";
    repo = pname;
    tag = "v${version}";
    hash = "sha256-ETgpXSUUsV1xoZjdnL2bzn4HwDjKC2t13yXwf28OBqI=";
  };

  pythonRelaxDeps = [
    "aiohttp"
    "async-timeout"
    "rich"
  ];

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [
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
    mainProgram = "surepy";
    homepage = "https://github.com/benleb/surepy";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
