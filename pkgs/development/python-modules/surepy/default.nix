{ lib
, aiodns
, aiohttp
, async-timeout
, brotlipy
, buildPythonPackage
, cchardet
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
  version = "0.6.0";
  format = "pyproject";
  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "benleb";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-XoYiZPBc9SybyKocui1HqSA+YPiPpbupJWMCfmQT5RU=";
  };

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [
    aiodns
    aiohttp
    async-timeout
    brotlipy
    cchardet
    click
    colorama
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
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
