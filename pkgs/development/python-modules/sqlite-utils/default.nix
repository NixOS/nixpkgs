{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, click
, click-default-group
, dateutils
, sqlite-fts4
, tabulate
, pytestCheckHook
, hypothesis
}:

buildPythonPackage rec {
  pname = "sqlite-utils";
  version = "3.17.1";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0cfde0c46a2d4c09d6df8609fe53642bc3ab443bcef3106d8f1eabeb3fccbe3d";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace '"pytest-runner"' ""
  '';

  propagatedBuildInputs = [
    click
    click-default-group
    dateutils
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
