{ lib, buildPythonPackage, fetchPypi, requests, six, requests_oauthlib }:

buildPythonPackage rec {
  pname = "tweepy";
  version = "3.10.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "76e6954b806ca470dda877f57db8792fff06a0beba0ed43efc3805771e39f06a";
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
