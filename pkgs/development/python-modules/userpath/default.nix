{ lib
, buildPythonPackage
, fetchPypi
, click
, distro
, tox
, pytest
, coverage
}:

buildPythonPackage rec {
  pname = "userpath";
  version = "1.4.1";

  src = fetchPypi {
    inherit pname version;
    sha256="0mfjmvx286z1dmnrc7bm65x8gj8qrmkcyagl0vf5ywfq0bm48591";
  };

  propagatedBuildInputs = [ click distro ];

  checkInputs = [ tox pytest coverage ];

  # We should skip tox dependencies installation to run tests but
  # tox doesn't have such an option yet (https://github.com/tox-dev/tox/issues/410)
  doCheck = false;

  checkPhase = ''
    tox
  '';

  meta = with lib; {
    description = "Cross-platform tool for adding locations to the user PATH";
    homepage = "https://github.com/ofek/userpath";
    license = [ licenses.asl20 licenses.mit ];
    maintainers = with maintainers; [ yevhenshymotiuk ];
  };
}
