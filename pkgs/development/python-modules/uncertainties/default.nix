{ stdenv, fetchPypi, buildPythonPackage, nose, numpy }:

buildPythonPackage rec {
  pname = "uncertainties";
  version = "3.0.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1hp00k10d5n69s446flss8b4rd02wq8dscvakv7ylfyf2p8y564s";
  };

  buildInputs = [ nose numpy ];

  # No tests included
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = https://pythonhosted.org/uncertainties/;
    description = "Transparent calculations with uncertainties on the quantities involved (aka error propagation)";
    maintainers = with maintainers; [ rnhmjoj ];
    license = licenses.bsd3;
  };
}
