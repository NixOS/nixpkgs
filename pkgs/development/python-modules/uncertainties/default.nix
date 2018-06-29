{ stdenv, fetchPypi, buildPythonPackage, nose, numpy }:

buildPythonPackage rec {
  pname = "uncertainties";
  version = "3.0.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "91db922d54dff6094b4ea0d6e058f713a992cdf42e3ebaf73278e1893bfa2942";
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
