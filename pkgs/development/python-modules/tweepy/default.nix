{ lib
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, oauthlib
, requests
, pythonOlder
, vcrpy
, pytestCheckHook
, requests_oauthlib
}:

buildPythonPackage rec {
  pname = "tweepy";
  version = "4.3.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-lS/98DRpJH1UGGNzwqVVUJOeul+BX+I3e+ysmC0oL3I=";
  };

  propagatedBuildInputs = [
    aiohttp
    oauthlib
    requests
    requests_oauthlib
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
