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
  version = "2.1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5a3ea5a13a8aac2d808864087fec87a0518bf7d9776173ab06a6bb4ade9f4d27";
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
