{ stdenv
, buildPythonPackage
, fetchPypi
, twitter-common-log
}:

buildPythonPackage rec {
  pname   = "twitter.common.confluence";
  version = "0.3.10";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8285cab3d31e4065a13575c1920101db4df0f36a59babcc225775e4fae91c0a1";
  };

  propagatedBuildInputs = [ twitter-common-log ];

  meta = with stdenv.lib; {
    description = "Twitter's API to the confluence wiki";
    homepage    = "https://twitter.github.io/commons/";
    license     = licenses.asl20;
    maintainers = with maintainers; [ copumpkin ];
  };

}
