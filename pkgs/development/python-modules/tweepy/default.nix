{ lib, buildPythonPackage, fetchPypi, requests, six, requests_oauthlib }:

buildPythonPackage rec {
  pname = "tweepy";
  version = "3.9.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "bfd19a5c11f35f7f199c795f99d9cbf8a52eb33f0ecfb6c91ee10b601180f604";
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
