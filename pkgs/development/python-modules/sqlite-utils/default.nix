{ lib
, buildPythonPackage
, fetchPypi
, fetchpatch
, pythonOlder
, click
, click-default-group
, python-dateutil
, sqlite-fts4
, tabulate
, pytestCheckHook
, hypothesis
}:

buildPythonPackage rec {
  pname = "sqlite-utils";
  version = "3.25.1";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-32lfUJoTbkflztLU/BDhbHbuOkW66OGpHLuiyAKFy8k=";
  };

  propagatedBuildInputs = [
    click
    click-default-group
    python-dateutil
    sqlite-fts4
    tabulate
  ];

  checkInputs = [
    pytestCheckHook
    hypothesis
  ];

  meta = with lib; {
    description = "Python CLI utility and library for manipulating SQLite databases";
    homepage = "https://github.com/simonw/sqlite-utils";
    license = licenses.asl20;
    maintainers = with maintainers; [ meatcar ];
  };
}
