{ lib, buildPythonPackage, fetchPypi, requests, six, requests_oauthlib }:

buildPythonPackage rec {
  pname = "tweepy";
  version = "3.5.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0n2shilamgwhzmvf534xg7f6hrnznbixyl5pw2f5a3f391gwy37h";
  };

  doCheck = false;
  propagatedBuildInputs = [ requests six requests_oauthlib ];

  meta = with lib; {
    homepage = https://github.com/tweepy/tweepy;
    description = "Twitter library for python";
    license = licenses.mit;
    maintainers = with maintainers; [ garbas ];
  };
}
