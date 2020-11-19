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
  version = "2.22";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "0g8zzp4qw6miijirykjcd78ib027k7dmg6lb9m4xysvah5jh8vfv";
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
