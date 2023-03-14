{ lib
, buildPythonPackage
, fetchPypi
, click
}:

buildPythonPackage rec {
  pname = "userpath";
  version = "1.7.0";

  src = fetchPypi {
    inherit pname version;
    sha256="sha256-3NZsX6mxo8EjYvMJu7W8eZK6yK+G0XtOaxpLFmoRxD8=";
  };

  propagatedBuildInputs = [ click ];

  # test suite is difficult to emulate in sandbox due to shell manipulation
  doCheck = false;

  pythonImportsCheck = [ "click" "userpath" ];

  meta = with lib; {
    description = "Cross-platform tool for adding locations to the user PATH";
    homepage = "https://github.com/ofek/userpath";
    license = [ licenses.asl20 licenses.mit ];
    maintainers = with maintainers; [ yshym ];
  };
}
