{ lib
, buildPythonPackage
, fetchFromGitHub
, requests
, requests_oauthlib
, pythonOlder
}:

buildPythonPackage rec {
  pname = "twitterapi";
  version = "2.7.12";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "geduldig";
    repo = "TwitterAPI";
    rev = "v${version}";
    sha256 = "sha256-WqeoIZt2OGDXKPAbjm3cHI1kgiCEJC6+ROXXx4TR4b4=";
  };

  propagatedBuildInputs = [
    requests
    requests_oauthlib
  ];

  # Tests are interacting with the Twitter API
  doCheck = false;

  pythonImportsCheck = [
    "TwitterAPI"
  ];

  meta = with lib; {
    description = "Python wrapper for Twitter's REST and Streaming APIs";
    homepage = "https://github.com/geduldig/TwitterAPI";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
