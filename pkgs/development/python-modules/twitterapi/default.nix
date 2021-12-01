{ lib
, buildPythonPackage
, fetchFromGitHub
, requests
, requests_oauthlib
}:

buildPythonPackage rec {
  pname = "twitterapi";
  version = "2.7.7";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "geduldig";
    repo = "TwitterAPI";
    rev = "v${version}";
    sha256 = "sha256-KEJ0lAg6Zi2vps+ZPTkT6ts87qnIBL9pFe1tPEzviCI=";
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
