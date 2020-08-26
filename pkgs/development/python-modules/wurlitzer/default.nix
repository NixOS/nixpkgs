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
  version = "2.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0hvmbc41kdwrjns8z1s4a59a4azdvzb8q3vs7nn1li4qm4l0g3yh";
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
