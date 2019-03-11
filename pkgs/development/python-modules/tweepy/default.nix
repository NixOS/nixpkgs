{ lib, buildPythonPackage, fetchPypi, fetchpatch, requests, six, requests_oauthlib }:

buildPythonPackage rec {
  pname = "tweepy";
  version = "3.7.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "fe85a79f58a01dd335968523b91c5fce760e7fe78bf25a6e71c72204fe499d0b";
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
