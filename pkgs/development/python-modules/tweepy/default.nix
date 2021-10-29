{ lib, buildPythonPackage, fetchPypi, requests, six, requests_oauthlib }:

buildPythonPackage rec {
  pname = "tweepy";
  version = "4.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "88e2938de5ac7043c9ba8b8358996fbc5806059d63c96269d22527a40ca7d511";
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
