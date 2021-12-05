{ lib, buildPythonPackage, fetchFromGitHub, requests, requests_oauthlib }:

buildPythonPackage rec {
  pname = "twitterapi";
  version = "2.7.9.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "geduldig";
    repo = "TwitterAPI";
    rev = "v${version}";
    sha256 = "sha256-3Ho8iw//X+eB7B/Q9TJGeoxAYjUJ96qsI1T3WYqZOpM=";
  };

  propagatedBuildInputs = [ requests requests_oauthlib ];

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
