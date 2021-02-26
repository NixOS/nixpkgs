{ lib
, buildPythonPackage
, fetchFromGitHub
, requests
, requests_oauthlib
}:

buildPythonPackage rec {
  pname = "twitterapi";
  version = "2.6.8";

  src = fetchFromGitHub {
    owner = "geduldig";
    repo = "TwitterAPI";
    rev = "v${version}";
    sha256 = "sha256-X/j+3bWLQ9b4q0k/JTE984o1VZS0KTQnC0AdZpNsksY=";
  };

  propagatedBuildInputs = [
    requests
    requests_oauthlib
  ];

  # Tests are interacting with the Twitter API
  doCheck = false;
  pythonImportsCheck = [ "TwitterAPI" ];

  meta = with lib; {
    description = "Python wrapper for Twitter's REST and Streaming APIs";
    homepage = "https://github.com/geduldig/TwitterAPI";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
