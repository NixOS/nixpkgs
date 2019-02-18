{ stdenv
, buildPythonPackage
, fetchPypi
, twitter-common-log
}:

buildPythonPackage rec {
  pname   = "twitter.common.confluence";
  version = "0.3.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1i2fjn23cmms81f1fhvvkg6hgzqpw07dlqg3ydz6cqv2glw7zq26";
  };

  propagatedBuildInputs = [ twitter-common-log ];

  meta = with stdenv.lib; {
    description = "Twitter's API to the confluence wiki";
    homepage    = "https://twitter.github.io/commons/";
    license     = licenses.asl20;
    maintainers = with maintainers; [ copumpkin ];
  };

}
