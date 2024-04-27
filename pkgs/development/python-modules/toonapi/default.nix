{ lib
, aiohttp
, backoff
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, yarl
}:

buildPythonPackage rec {
  pname = "toonapi";
  version = "0.3.0";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "frenck";
    repo = "python-toonapi";
    rev = "refs/tags/v${version}";
    hash = "sha256-RaN9ppqJbTik1/vNX0/YLoBawrqjyQWU6+FLTspIxug=";
  };

  propagatedBuildInputs = [
    aiohttp
    backoff
    yarl
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [
    "toonapi"
  ];

  meta = with lib; {
    description = "Python client for the Quby ToonAPI";
    homepage = "https://github.com/frenck/python-toonapi";
    changelog = "https://github.com/frenck/python-toonapi/releases/tag/v${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
