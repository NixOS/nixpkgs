{ lib
, aiodns
, aiohttp
, async-timeout
, attrs
, brotlipy
, buildPythonPackage
, faust-cchardet
, click
, colorama
, fetchFromGitHub
, halo
, poetry-core
, pythonOlder
, requests
, rich
}:

buildPythonPackage rec {
  pname = "surepy";
  version = "0.9.0";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "benleb";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-ETgpXSUUsV1xoZjdnL2bzn4HwDjKC2t13yXwf28OBqI=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'aiohttp = {extras = ["speedups"], version = "^3.7.4"}' 'aiohttp = {extras = ["speedups"], version = ">=3.7.4"}' \
      --replace 'async-timeout = "^3.0.1"' 'async-timeout = ">=3.0.1"' \
      --replace 'rich = "^10.1.0"' 'rich = ">=10.1.0"'
  '';

  nativeBuildInputs = [
    poetry-core
  ];

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

  pythonImportsCheck = [
    "surepy"
  ];

  meta = with lib; {
    description = "Python library to interact with the Sure Petcare API";
    homepage = "https://github.com/benleb/surepy";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
