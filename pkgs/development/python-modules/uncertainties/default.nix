{ stdenv, fetchPypi, buildPythonPackage, nose, numpy }:

buildPythonPackage rec {
  pname = "uncertainties";
  version = "3.1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "18b184110cbe31303d25a7bc7f73d51b9cb4e15563cb9aa25ccfbd0ebe07d448";
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
