{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, click
, click-default-group
, sqlite-fts4
, tabulate
, pytestCheckHook
, pytestrunner
, black
, hypothesis
, sqlite
}:

buildPythonPackage rec {
  pname = "sqlite-utils";
  version = "3.2";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "83d60e0f0de5e4a367e2ad414dc008c0602e2af35325b09e41c7b2c69808dcc1";
  };

  propagatedBuildInputs = [
    click
    click-default-group
    sqlite-fts4
    tabulate
  ];

  checkInputs = [
    pytestCheckHook
    pytestrunner
    black
    hypothesis
  ];

  # disabled until upstream updates tests
  disabledTests = lib.optionals (lib.versionAtLeast sqlite.version "3.34.0") [
    "test_optimize"
  ];

  meta = with lib; {
    description = "Python CLI utility and library for manipulating SQLite databases";
    homepage = "https://github.com/simonw/sqlite-utils";
    license = licenses.asl20;
    maintainers = with maintainers; [ meatcar ];
  };

}
