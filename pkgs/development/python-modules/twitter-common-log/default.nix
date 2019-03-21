{ stdenv
, buildPythonPackage
, fetchPypi
, twitter-common-options
, twitter-common-dirutil
}:

buildPythonPackage rec {
  pname   = "twitter.common.log";
  version = "0.3.10";

  src = fetchPypi {
    inherit pname version;
    sha256 = "81af4b0f51f3fb589f39b410d7031da6792e0ae650a45e9207a25a52a343a555";
  };

  propagatedBuildInputs = [ twitter-common-options twitter-common-dirutil ];

  meta = with stdenv.lib; {
    description = "Twitter's common logging library";
    homepage    = "https://twitter.github.io/commons/";
    license     = licenses.asl20;
    maintainers = with maintainers; [ copumpkin ];
  };

}
