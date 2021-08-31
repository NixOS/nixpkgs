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
  version = "3.0.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "36051ac530ddb461a86b6227c4b09d95f30a1d1043de2b4a592e97ae8a84fcdf";
  };

  propagatedBuildInputs = lib.optionals isPy27 [ selectors2 ];

  checkInputs = [ mock pytest ];

  checkPhase = ''
    py.test test.py
  '';

  meta = {
    description = "Capture C-level output in context managers";
    homepage = "https://github.com/minrk/wurlitzer";
    license = lib.licenses.mit;
  };
}
