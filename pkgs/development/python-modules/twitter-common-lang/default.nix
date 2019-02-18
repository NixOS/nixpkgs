{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname   = "twitter.common.lang";
  version = "0.3.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1l8fmnsrx7hgg3ivslg588rnl9n1gfjn2w6224fr8rs7zmkd5lan";
  };

  meta = with stdenv.lib; {
    description = "Twitter's 2.x / 3.x compatibility swiss-army knife";
    homepage    = "https://twitter.github.io/commons/";
    license     = licenses.asl20;
    maintainers = with maintainers; [ copumpkin ];
  };

}
