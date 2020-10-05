{ stdenv, buildPythonPackage, fetchPypi, nose }:

buildPythonPackage rec {
  pname = "voluptuous";
  version = "0.12.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3a4ef294e16f6950c79de4cba88f31092a107e6e3aaa29950b43e2bb9e1bb2dc";
  };

  checkInputs = [ nose ];

  meta = with stdenv.lib; {
    description = "Voluptuous is a Python data validation library";
    homepage = "http://alecthomas.github.io/voluptuous/";
    license = licenses.bsd3;
  };
}
