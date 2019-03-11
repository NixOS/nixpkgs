{ stdenv
, buildPythonPackage
, fetchPypi
, twitter-common-lang
}:

buildPythonPackage rec {
  pname   = "twitter.common.collections";
  version = "0.3.10";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c27f11612572f614cadf181cc65bcd0275d8b08f182bcb4ea1b74cd662625f21";
  };

  propagatedBuildInputs = [ twitter-common-lang ];

  meta = with stdenv.lib; {
    description = "Twitter's common collections";
    homepage    = "https://twitter.github.io/commons/";
    license     = licenses.asl20;
    maintainers = with maintainers; [ copumpkin ];
  };

}
