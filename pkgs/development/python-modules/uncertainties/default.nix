{ lib, stdenv, fetchPypi, buildPythonPackage
, nose, numpy, future
}:

buildPythonPackage rec {
  pname = "uncertainties";
  version = "3.1.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "00z9xl40czmqk0vmxjvmjvwb41r893l4dad7nj1nh6blw3kw28li";
  };

  propagatedBuildInputs = [ future ];
  checkInputs = [ nose numpy ];

  checkPhase = "python setup.py nosetests -sv";

  meta = with lib; {
    homepage = "https://pythonhosted.org/uncertainties/";
    description = "Transparent calculations with uncertainties on the quantities involved (aka error propagation)";
    maintainers = with maintainers; [ rnhmjoj ];
    license = licenses.bsd3;
  };
}
