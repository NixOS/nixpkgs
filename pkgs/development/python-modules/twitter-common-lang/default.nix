{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname   = "twitter.common.lang";
  version = "0.3.10";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9cd2d05a7f45c50c76c99024b3cad180bec42b0c65dfdc1f8ddc731bdd3b3af8";
  };

  meta = with stdenv.lib; {
    description = "Twitter's 2.x / 3.x compatibility swiss-army knife";
    homepage    = "https://twitter.github.io/commons/";
    license     = licenses.asl20;
    maintainers = with maintainers; [ copumpkin ];
  };

}
