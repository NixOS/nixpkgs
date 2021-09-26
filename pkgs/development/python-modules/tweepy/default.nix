{ lib, buildPythonPackage, fetchPypi, requests, six, requests_oauthlib }:

buildPythonPackage rec {
  pname = "tweepy";
  version = "4.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b28d72073b794141ad1cfdc34cb52b83b14d6b34cd4c5ea9d47bb85159b656e8";
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
