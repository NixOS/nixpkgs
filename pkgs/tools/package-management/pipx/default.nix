{ lib
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "pipx";
  version = "1.2.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "pipxproject";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-lm/Q+8nNubhaUR1pUbSIoD4DEUEkK+pQvvUdWNquW4Q=";
  };

  nativeBuildInputs = with python3.pythonForBuild.pkgs; [
    hatchling
  ];

  propagatedBuildInputs = with python3.pkgs; [
    argcomplete
    packaging
    platformdirs
    userpath
  ];

  nativeCheckInputs = with python3.pkgs; [
    pytestCheckHook
  ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  pytestFlagsArray = [
    "--ignore=tests/test_install_all_packages.py"
    # start local pypi server and use in tests
    "--net-pypiserver"
  ];

  disabledTests = [
    # disable tests which are difficult to emulate due to shell manipulations
    "path_warning"
    "script_from_internet"
    "ensure_null_pythonpath"
    # disable tests, which require internet connection
    "install"
    "inject"
    "ensure_null_pythonpath"
    "missing_interpreter"
    "cache"
    "internet"
    "run"
    "runpip"
    "upgrade"
    "suffix"
    "legacy_venv"
    "determination"
    "json"
    "test_list_short"
  ];

  meta = with lib; {
    description = "Install and run Python applications in isolated environments";
    homepage = "https://github.com/pipxproject/pipx";
    changelog = "https://github.com/pypa/pipx/blob/${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ yshym ];
  };
}
