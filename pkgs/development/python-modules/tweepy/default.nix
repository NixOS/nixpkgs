{ lib, buildPythonPackage, fetchPypi, requests, six, requests_oauthlib }:

buildPythonPackage rec {
  pname = "tweepy";
  version = "4.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3bbb14a0ddef1ca8c9e8686ab2f647163afa02a6bab83507335ce647e9653a90";
  };

  doCheck = false;
  propagatedBuildInputs = [ requests six requests_oauthlib ];

  meta = with lib; {
    homepage = "https://github.com/tweepy/tweepy";
    description = "Twitter library for python";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
