{ lib
, buildPythonPackage
, fetchPypi
, click
}:

buildPythonPackage rec {
  pname = "userpath";
  version = "1.5.0";

  src = fetchPypi {
    inherit pname version;
    sha256="0fj2lj9vcns5sxv72v3ggrszcl7j1jd9a6ycnsl00218nycliy31";
  };

  propagatedBuildInputs = [ click ];

  # test suite is difficult to emulate in sandbox due to shell manipulation
  doCheck = false;

  pythonImportsCheck = [ "click" "userpath" ];

  meta = with lib; {
    description = "Cross-platform tool for adding locations to the user PATH";
    homepage = "https://github.com/ofek/userpath";
    license = [ licenses.asl20 licenses.mit ];
    maintainers = with maintainers; [ yevhenshymotiuk ];
  };
}
