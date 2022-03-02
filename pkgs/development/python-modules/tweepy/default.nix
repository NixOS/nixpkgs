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
  version = "4.6.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-7ogsocRTMTO5yegyY7BADu9NrHK7zMMbihBu8oF4UlQ=";
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
