{ lib
, aiodns
, aiohttp
, async-timeout
, attrs
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
  version = "0.7.1";
  format = "pyproject";
  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "benleb";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-h2PEzS3R7NXIUWYOiTpe5ZEU1RopaRj1phudmvcklug=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'click = "^7.1.2"' 'click = "*"' \
      --replace 'attrs = "^20.3.0"' 'attrs = "*"'
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
