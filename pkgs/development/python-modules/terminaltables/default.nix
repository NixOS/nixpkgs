{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "terminaltables";
  version = "3.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f3eb0eb92e3833972ac36796293ca0906e998dc3be91fbe1f8615b331b853b81";
  };

  meta = with stdenv.lib; {
    description = "Display simple tables in terminals";
    homepage = "https://github.com/Robpol86/terminaltables";
    license = licenses.mit;
  };

}
