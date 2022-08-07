{ lib
, fetchFromGitHub
, python3
}:

let
  setoptconf-tmp = python3.pkgs.callPackage ./setoptconf.nix { };
in

with python3.pkgs;

buildPythonApplication rec {
  pname = "prospector";
  version = "1.7.7";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "PyCQA";
    repo = pname;
    rev = version;
    hash = "sha256-sbPZmVeJtNphtjuZEfKcUgty9bJ3E/2Ya9RuX3u/XEs=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    bandit
    dodgy
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

  checkInputs = [
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'requirements-detector = "^0.7"' 'requirements-detector = "*"' \
      --replace 'pep8-naming = ">=0.3.3,<=0.10.0"' 'pep8-naming = "*"' \
      --replace 'mccabe = "^0.6.0"' 'mccabe = "*"'
  '';

  pythonImportsCheck = [
    "prospector"
  ];

  meta = with lib; {
    description = "Tool to analyse Python code and output information about errors, potential problems, convention violations and complexity";
    homepage = "https://github.com/PyCQA/prospector";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ kamadorueda ];
  };
}
