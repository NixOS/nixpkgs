{ stdenv
, buildPythonPackage
, fetchPypi
, twitter-common-options
, twitter-common-dirutil
}:

buildPythonPackage rec {
  pname   = "twitter.common.log";
  version = "0.3.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1bdzbxx2bxwpf57xaxfz1nblzgfvhlidz8xqd7s84c62r3prh02v";
  };

  propagatedBuildInputs = [ twitter-common-options twitter-common-dirutil ];

  meta = with stdenv.lib; {
    description = "Twitter's common logging library";
    homepage    = "https://twitter.github.io/commons/";
    license     = licenses.asl20;
    maintainers = with maintainers; [ copumpkin ];
  };

}
