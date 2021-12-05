{ lib, stdenv, buildPythonPackage, fetchPypi, click, pytestCheckHook
, shellingham, pytest-xdist, pytest-sugar, coverage, mypy, black, isort
, pythonOlder }:

buildPythonPackage rec {
  pname = "typer";
  version = "0.4.0";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1pgm0zsylbmz1r96q4n3rfi0h3pn4jss2yfs83z0yxa90nmsxhv3";
  };

  propagatedBuildInputs = [ click ];

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
  disabledTests = lib.optionals stdenv.isDarwin [
    # likely related to https://github.com/sarugaku/shellingham/issues/35
    "test_show_completion"
    "test_install_completion"
  ];

  pythonImportsCheck = [ "typer" ];

  meta = with lib; {
    description = "Python library for building CLI applications";
    homepage = "https://typer.tiangolo.com/";
    license = licenses.mit;
    maintainers = with maintainers; [ winpat ];
  };
}
