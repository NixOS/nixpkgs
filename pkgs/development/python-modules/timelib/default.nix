{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "timelib";
  version = "0.2.5";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "6ac9f79b09b63bbc07db88525c1f62de1f6d50b0fd9937a0cb05e3d38ce0af45";
  };

  meta = with lib; {
    description = "Parse english textual date descriptions";
    homepage = "https://github.com/pediapress/timelib/";
    license = licenses.zlib;
  };

}
