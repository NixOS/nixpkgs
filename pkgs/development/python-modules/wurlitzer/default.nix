{ lib
, buildPythonPackage
, fetchPypi
, mock
, pytest
}:

buildPythonPackage rec {
  pname = "wurlitzer";
  version = "1.0.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "23e85af0850b98add77bef0a1eb47b243baab29160131d349234c9dfc9e57add";
  };

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