{ lib
, buildPythonPackage
, fetchPypi
, click
, pytestCheckHook
, shellingham
, pytest-cov
, pytest-xdist
, pytest-sugar
, coverage
, mypy
, black
, isort
}:

buildPythonPackage rec {
  pname = "typer";
  version = "0.3.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "00v3h63dq8yxahp9vg3yb9r27l2niwv8gv0dbds9dzrc298dfmal";
  };

  propagatedBuildInputs = [ click ];

  checkInputs = [
    pytestCheckHook
    pytest-cov
    pytest-xdist
    pytest-sugar
    shellingham
    coverage
    mypy
    black
    isort
  ];
  pytestFlagsArray = [
    "--ignore=tests/test_completion/test_completion.py"
    "--ignore=tests/test_completion/test_completion_install.py"
  ];

  meta = with lib; {
    homepage = "https://typer.tiangolo.com/";
    description = "Typer, build great CLIs. Easy to code. Based on Python type hints.";
    license = licenses.mit;
    # is incompatible with click8
    # https://github.com/tiangolo/typer/issues/280
    broken = true;
    maintainers = [ maintainers.winpat ];
  };
}
