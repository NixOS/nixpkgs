{ lib
, pkgs
, python
}:

let
  py = python.override {
    packageOverrides = self: super: {
      pep8-naming = super.pep8-naming.overridePythonAttrs(oldAttrs: rec {
        version = "0.4.1";
        src = oldAttrs.src.override {
          inherit version;
          sha256 = "0nhf8p37y008shd4f21bkj5pizv8q0l8cpagyyb8gr059d6gvvaf";
        };
      });
    };
  };
  setoptconf = py.pkgs.callPackage ./setoptconf.nix { };
in

with py.pkgs;

buildPythonApplication rec {
  pname = "prospector";
  version = "1.2.0";
  disabled = isPy27;

  src = pkgs.fetchFromGitHub {
    owner = "PyCQA";
    repo = pname;
    rev = version;
    sha256 = "07kb37zrrsriqzcmli0ghx7qb1iwkzh83qsiikl9jy50faby2sjg";
  };

  checkInputs = [
    pytest
  ];

  checkPhase = ''
    pytest
  '';

  patchPhase = ''
    substituteInPlace setup.py \
      --replace 'pycodestyle<=2.4.0' 'pycodestyle<=2.5.0'
  '';

  propagatedBuildInputs = [
    astroid
    django
    dodgy
    mccabe
    pep8-naming
    pycodestyle
    pydocstyle
    pyflakes
    pylint
    pylint-celery
    pylint-django
    pylint-flask
    pyyaml
    requirements-detector
    setoptconf
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
