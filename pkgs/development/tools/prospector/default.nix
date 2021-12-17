{ lib
, pkgs
, python3
}:

let
  setoptconf-tmp = python3.pkgs.callPackage ./setoptconf.nix { };
in

with python3.pkgs;

buildPythonApplication rec {
  pname = "prospector";
  version = "1.5.1";
  format = "pyproject";
  disabled = pythonOlder "3.6.1";

  src = pkgs.fetchFromGitHub {
    owner = "PyCQA";
    repo = pname;
    rev = version;
    sha256 = "17f822cxrvcvnrzdx1a9fyi9afljq80b6g6z1k2bqa1vs21gwv7l";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'pep8-naming = ">=0.3.3,<=0.10.0"' 'pep8-naming = "*"'
  '';

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

  meta = with lib; {
    description = "Tool to analyse Python code and output information about errors, potential problems, convention violations and complexity";
    homepage = "https://github.com/PyCQA/prospector";
    license = licenses.gpl2;
    maintainers = with maintainers; [
      kamadorueda
    ];
  };
}
