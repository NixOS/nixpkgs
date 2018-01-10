{ stdenv, fetchPypi, buildPythonPackage, nose, numpy }:

buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "uncertainties";
  version = "3.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "de0765cac6911e5afa93ee941063a07b4a98dbd9c314c5eea4ab14bfff0054a4";
  };

  buildInputs = [ nose numpy ];

  # No tests included
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = http://pythonhosted.org/uncertainties/;
    description = "Transparent calculations with uncertainties on the quantities involved (aka error propagation)";
    maintainers = with maintainers; [ rnhmjoj ];
    license = licenses.bsd3;
  };
}
