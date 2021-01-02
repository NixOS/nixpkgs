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
  version = "3.1.1";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "54df73364662ff3c763da3b42b9d27b1771ebfb3361caa255e44e1bf1544015b";
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
