{ lib, fetchPypi, buildPythonPackage
, nose, numpy, future
}:

buildPythonPackage rec {
  pname = "uncertainties";
  version = "3.1.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-gBEeCDnyOcWyM8tHcgF7SDoLehVzpYG5Krd0ajXm+qs=";
  };

  propagatedBuildInputs = [ future ];
  nativeCheckInputs = [ nose numpy ];

  checkPhase = ''
    nosetests -sv
  '';

  meta = with lib; {
    homepage = "https://pythonhosted.org/uncertainties/";
    description = "Transparent calculations with uncertainties on the quantities involved (aka error propagation)";
    maintainers = with maintainers; [ rnhmjoj ];
    license = licenses.bsd3;
  };
}
