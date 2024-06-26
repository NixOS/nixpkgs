{ lib
, fetchFromGitHub
, python3
}:

let
  setoptconf-tmp = python3.pkgs.callPackage ./setoptconf.nix { };
in

python3.pkgs.buildPythonApplication rec {
  pname = "prospector";
  version = "1.9.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "PyCQA";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-94JGKX91d2kul+KMYohga9KCOj6RN/YKpD8e4nWSOOM=";
  };

  pythonRelaxDeps = [
    "pyflakes"
    "pep8-naming"
    "flake8"
  ];

  nativeBuildInputs = with python3.pkgs; [
    poetry-core
    pythonRelaxDepsHook
  ];

  propagatedBuildInputs = with python3.pkgs; [
    bandit
    dodgy
    flake8
    gitpython
    mccabe
    mypy
    pep8-naming
    pycodestyle
    pydocstyle
    pyflakes
    pylint
    pylint-celery
    pylint-django
    pylint-flask
    pylint-plugin-utils
    pyroma
    pyyaml
    requirements-detector
    setoptconf-tmp
    setuptools
    toml
    vulture
  ];

  nativeCheckInputs = with python3.pkgs; [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "prospector"
  ];

  disabledTestPaths = [
    # distutils.errors.DistutilsArgError: no commands supplied
    "tests/tools/pyroma/test_pyroma_tool.py"
  ];


  meta = with lib; {
    description = "Tool to analyse Python code and output information about errors, potential problems, convention violations and complexity";
    homepage = "https://github.com/PyCQA/prospector";
    changelog = "https://github.com/PyCQA/prospector/blob/v${version}/CHANGELOG.rst";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ kamadorueda ];
  };
}
