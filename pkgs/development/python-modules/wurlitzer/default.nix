{ lib
, buildPythonPackage
, fetchPypi
, isPy27
, mock
, pytest
, selectors2
}:

buildPythonPackage rec {
  pname = "wurlitzer";
  version = "2.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0xndv47iwc9k8cp5r9r1z3r0xww0r5x5b7qsmn39gk2gsg0119c6";
  };

  propagatedBuildInputs = lib.optionals isPy27 [ selectors2 ];

  checkInputs = [ mock pytest ];

  checkPhase = ''
    py.test test.py
  '';

  meta = {
    description = "Capture C-level output in context managers";
    homepage = https://github.com/minrk/wurlitzer;
    license = lib.licenses.mit;
  };
}
