{ stdenv, buildPythonPackage, fetchPypi, nose }:

buildPythonPackage rec {
  pname = "voluptuous";
  version = "0.11.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "567a56286ef82a9d7ae0628c5842f65f516abcb496e74f3f59f1d7b28df314ef";
  };

  checkInputs = [ nose ];

  meta = with stdenv.lib; {
    description = "Voluptuous is a Python data validation library";
    homepage = http://alecthomas.github.io/voluptuous/;
    license = licenses.bsd3;
  };
}
