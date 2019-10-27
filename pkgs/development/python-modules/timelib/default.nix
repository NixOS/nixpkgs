{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "timelib";
  version = "0.2.4";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "49142233bdb5971d64a41e05a1f80a408a02be0dc7d9f8c99e7bdd0613ba81cb";
  };

  meta = with stdenv.lib; {
    description = "Parse english textual date descriptions";
    homepage = "https://github.com/pediapress/timelib/";
    license = licenses.zlib;
  };

}
