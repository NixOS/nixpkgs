{ lib
, stdenv
, buildPythonPackage
, fetchpatch
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
  version = "0.4.1";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-Vkau8Nk2ssdhoQOT8DhO5rXH/guz5c1xCxcTTKHZnP8=";
  };

  patches = [
    (fetchpatch {
      # use get_terminal_size from shutil; click 8.1.0 compat
      # https://github.com/tiangolo/typer/pull/375
      name = "typer-click-8.1-compat.patch";
      url = "https://github.com/tiangolo/typer/commit/b6efa2f8f40291fd80cf146b617e0ba305f6af3c.patch";
      hash = "sha256-m0EWpBUt5njoPsn043b30WdAQELYNn2ycHXBxZCYXZE=";
    })
  ];

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
