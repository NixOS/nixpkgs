{
  lib,
  buildPythonPackage,
  fetchPypi,
  twitter-common-log,
}:

buildPythonPackage rec {
  pname = "twitter.common.confluence";
  version = "0.3.11";

  src = fetchPypi {
    inherit pname version;
    sha256 = "323dde2c519f85020569d7a343432f3aac16bce6ebe5e34774dbde557296697c";
  };

  propagatedBuildInputs = [ twitter-common-log ];

  meta = with lib; {
    description = "Twitter's API to the confluence wiki";
    homepage = "https://twitter.github.io/commons/";
    license = licenses.asl20;
    maintainers = with maintainers; [ copumpkin ];
  };
}
