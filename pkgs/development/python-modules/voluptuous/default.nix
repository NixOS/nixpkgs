{ stdenv, buildPythonPackage, fetchPypi, nose }:

buildPythonPackage rec {
  pname = "voluptuous";
  version = "0.10.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "15i3gaap8ilhpbah1ffc6q415wkvliqxilc6s69a4rinvkw6cx3s";
  };

  checkInputs = [ nose ];

  meta = with stdenv.lib; {
    description = "Voluptuous is a Python data validation library";
    homepage = http://alecthomas.github.io/voluptuous/;
    license = licenses.bsd3;
  };
}
