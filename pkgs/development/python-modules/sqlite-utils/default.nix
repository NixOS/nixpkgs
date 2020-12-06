{ lib
, buildPythonPackage
, fetchPypi
, isPy3k
, click
, click-default-group
, tabulate
, pytestCheckHook
, pytestrunner
, black
}:

buildPythonPackage rec {
  pname = "sqlite-utils";
  version = "3.0";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "a158265fde85a6757b7f09b568b1f7d6eaf75eaae208be27336f09dc048e5bcf";
  };

  propagatedBuildInputs = [
    click
    click-default-group
    tabulate
  ];

  checkInputs = [
    pytestCheckHook
    pytestrunner
    black
  ];

  meta = with lib; {
    description = "Python CLI utility and library for manipulating SQLite databases";
    homepage = "https://github.com/simonw/sqlite-utils";
    license = licenses.asl20;
    maintainers = [ maintainers.meatcar ];
  };

}
