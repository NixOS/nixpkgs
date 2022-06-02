{ lib, fetchPypi, buildPythonPackage
, nose, numpy, future
}:

buildPythonPackage rec {
  pname = "uncertainties";
  version = "3.1.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0b9y0v73ih142bygi66dxqx17j2x4dfvl7xnhmafj9yjmymbakbw";
  };

  propagatedBuildInputs = [ future ];
  checkInputs = [ nose numpy ];

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
