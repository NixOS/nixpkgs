{ lib
, buildPythonPackage
, fetchPypi
, click
, distro
}:

buildPythonPackage rec {
  pname = "userpath";
  version = "1.4.1";

  src = fetchPypi {
    inherit pname version;
    sha256="0mfjmvx286z1dmnrc7bm65x8gj8qrmkcyagl0vf5ywfq0bm48591";
  };

  requiredPythonModules = [ click distro ];

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
