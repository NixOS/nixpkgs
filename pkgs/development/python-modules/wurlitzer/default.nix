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
  version = "3.0.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-Ik9f5wYYvjhywF393IxFcZHsGHBlRZYnn8we2t6+Pls=";
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
