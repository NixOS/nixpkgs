{ stdenv, buildPythonPackage, fetchPypi, nose }:

buildPythonPackage rec {
  pname = "voluptuous";
  version = "0.11.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "af7315c9fa99e0bfd195a21106c82c81619b42f0bd9b6e287b797c6b6b6a9918";
  };

  checkInputs = [ nose ];

  meta = with stdenv.lib; {
    description = "Voluptuous is a Python data validation library";
    homepage = http://alecthomas.github.io/voluptuous/;
    license = licenses.bsd3;
  };
}
