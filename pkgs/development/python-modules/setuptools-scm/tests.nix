{ buildPythonPackage
, setuptools-scm
, pytestCheckHook
, git
, mercurial
, pip
, virtualenv
}:

buildPythonPackage rec {
  pname = "setuptools-scm-tests";
  inherit (setuptools-scm) version;

  src = setuptools-scm.src;

  dontBuild = true;
  dontInstall = true;

  checkInputs = [
    pytestCheckHook
    setuptools-scm
    pip
    virtualenv
    git
    mercurial
  ];

  disabledTests = [
    # network access
    "test_pip_download"
  ];
}
