{ lib, buildPythonPackage, fetchPypi, fetchpatch, requests, six, requests_oauthlib }:

buildPythonPackage rec {
  pname = "tweepy";
  version = "3.6.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "901500666de5e265d93e611dc05066bb020481c85550d6bcbf8030212938902c";
  };

  # Fix build with pip 10
  # https://github.com/tweepy/tweepy/pull/1030
  patches = fetchpatch {
    url = "${meta.homepage}/commit/778bd7a31d2f5fae98652735e7844533589ca221.patch";
    sha256 = "1sqmjn0ngiynhfkdkcs33qmvl49ysfp8522hvxjk8bx252y9qw2h";
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
