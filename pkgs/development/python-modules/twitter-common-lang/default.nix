{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "twitter.common.lang";
  version = "0.3.11";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6e967ca2b5bb96ea749d21052f45b18e37deb5cc160eb12c64a8f1cb9dba7a22";
  };

  meta = with lib; {
    description = "Twitter's 2.x / 3.x compatibility swiss-army knife";
    homepage = "https://twitter.github.io/commons/";
    license = licenses.asl20;
    maintainers = with maintainers; [ copumpkin ];
  };
}
