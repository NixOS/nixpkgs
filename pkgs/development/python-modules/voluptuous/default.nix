{ stdenv, buildPythonPackage, fetchPypi, nose }:

buildPythonPackage rec {
  pname = "voluptuous";
  version = "0.12.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1p5j3fgbpqj31fajkaisdrz10ah9667sijz4kp3m0sbgw6ag4kis";
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
