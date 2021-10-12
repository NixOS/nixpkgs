{ lib
, buildPythonPackage
, fetchPypi
, click
, pytestCheckHook
, shellingham
, pytest-xdist
, pytest-sugar
, coverage
, mypy
, black
, isort
, pythonOlder
}:

buildPythonPackage rec {
  pname = "typer";
  version = "0.4.0";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1pgm0zsylbmz1r96q4n3rfi0h3pn4jss2yfs83z0yxa90nmsxhv3";
  };

  propagatedBuildInputs = [
    click
  ];

  checkInputs = [
    pytestCheckHook
    pytest-xdist
    pytest-sugar
    shellingham
    coverage
    mypy
    black
    isort
  ];

  preCheck = ''
    export HOME=$(mktemp -d);
  '';

  pythonImportsCheck = [ "typer" ];

  meta = with lib; {
    description = "Python library for building CLI applications";
    homepage = "https://typer.tiangolo.com/";
    license = licenses.mit;
    maintainers = with maintainers; [ winpat ];
  };
}
