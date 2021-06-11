{ lib
, buildPythonPackage
, fetchPypi
, click
}:

buildPythonPackage rec {
  pname = "userpath";
  version = "1.6.0";

  src = fetchPypi {
    inherit pname version;
    sha256="1xpgdmdvhmmmdlivsqlzx1xvyj0gcnfp0j2ba5izmv3q2k5abfdj";
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
