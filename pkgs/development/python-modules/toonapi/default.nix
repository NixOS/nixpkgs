{ lib
, aiohttp
, backoff
, buildPythonPackage
, fetchFromGitHub
, yarl
}:

buildPythonPackage rec {
  pname = "toonapi";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "frenck";
    repo = "python-toonapi";
    rev = "v${version}";
    sha256 = "1d4n615vlcgkvmchrfjw4h3ndav3ljmcfydxr2b41zn83mzizqdf";
  };

  propagatedBuildInputs = [
    aiohttp
    backoff
    yarl
  ];

  # Project has no tests
  doCheck = false;
  pythonImportsCheck = [ "toonapi" ];

  meta = with lib; {
    description = "Python client for the Quby ToonAPI";
    homepage = "https://github.com/frenck/python-toonapi";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
