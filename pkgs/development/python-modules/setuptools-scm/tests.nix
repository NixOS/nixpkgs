{ buildPythonPackage
, setuptools-scm
, pytestCheckHook
, git
, mercurial
, pip
, virtualenv
}:

buildPythonPackage {
  pname = "setuptools-scm-tests";
  inherit (setuptools-scm) version src;
  format = "other";

  dontBuild = true;
  dontInstall = true;

  nativeCheckInputs = [
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
