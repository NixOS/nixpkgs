{ lib
, buildPythonPackage
, fetchFromGitHub
, requests
, requests_oauthlib
, pythonOlder
}:

buildPythonPackage rec {
  pname = "twitterapi";
  version = "2.7.11";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "geduldig";
    repo = "TwitterAPI";
    rev = "v${version}";
    sha256 = "sha256-Rxc0ld0U8fhE3yJV+rgGsOfOdN6xGk0NQuHscpvergs=";
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
