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
  version = "0.5.0";
  format = "pyproject";
  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "benleb";
    repo = pname;
    rev = "v${version}";
    sha256 = "1adsnjya142bxdhfxqsi2qa35ylvdcibigs1wafjlxazlxs3mg0j";
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

  postPatch = ''
    # halo is out-dated, https://github.com/benleb/surepy/pull/7
    substituteInPlace pyproject.toml --replace "^0.0.30" "^0.0.31"
  '';

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
