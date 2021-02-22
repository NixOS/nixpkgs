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
  version = "3.5";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-i9SnT+DcQOcujV25bD/SNV1uRA2IgfiSWhEWlQC5TiA=";
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

  meta = with lib; {
    description = "Python CLI utility and library for manipulating SQLite databases";
    homepage = "https://github.com/simonw/sqlite-utils";
    license = licenses.asl20;
    maintainers = with maintainers; [ meatcar ];
  };

}
