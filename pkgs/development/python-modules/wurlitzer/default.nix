{ lib
, buildPythonPackage
, fetchPypi
, mock
, pytest
}:

buildPythonPackage rec {
  pname = "wurlitzer";
  version = "1.0.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0nab45pfgqdxhhyshf717xfzniss2h3bx19zdaq9gqr6v8lw6wpr";
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