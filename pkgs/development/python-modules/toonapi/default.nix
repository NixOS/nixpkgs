{ lib
, aiohttp
, backoff
, buildPythonPackage
, fetchFromGitHub
, yarl
}:

buildPythonPackage rec {
  pname = "toonapi";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "frenck";
    repo = "python-toonapi";
    rev = "v${version}";
    sha256 = "10jh6p0ww51cb9f8amd9jq3lmvby6n2k08qwcr2n8ijbbgyp0ibf";
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
