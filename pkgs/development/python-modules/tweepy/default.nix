{ lib
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, oauthlib
, pytestCheckHook
, pythonOlder
, requests
, requests-oauthlib
, vcrpy
}:

buildPythonPackage rec {
  pname = "tweepy";
  version = "4.8.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    hash = "sha256-RaM2JN2WOHyZY+AxzgQLvhXg6UnevDbSFSR4jFLsYrc=";
  };

  propagatedBuildInputs = [
    aiohttp
    oauthlib
    requests
    requests-oauthlib
  ];

  checkInputs = [
    pytestCheckHook
    vcrpy
  ];

  pythonImportsCheck = [
    "tweepy"
  ];

  meta = with lib; {
    homepage = "https://github.com/tweepy/tweepy";
    description = "Twitter library for Python";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
