{ stdenv, buildPythonPackage, fetchPypi, nose }:

buildPythonPackage rec {
  pname = "voluptuous";
  version = "0.12.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0js4avmhmmys78z376xk1w9305hq5nad8zqrnksgmpc1j90p4db6";
  };

  checkInputs = [ nose ];
  checkPhase = ''
    nosetests
  '';

  meta = with stdenv.lib; {
    description = "Voluptuous is a Python data validation library";
    homepage = "http://alecthomas.github.io/voluptuous/";
    license = licenses.bsd3;
  };
}
