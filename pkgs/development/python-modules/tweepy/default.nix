{ lib, buildPythonPackage, fetchPypi, requests, six, requests_oauthlib }:

buildPythonPackage rec {
  pname = "tweepy";
  version = "3.6.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "901500666de5e265d93e611dc05066bb020481c85550d6bcbf8030212938902c";
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
