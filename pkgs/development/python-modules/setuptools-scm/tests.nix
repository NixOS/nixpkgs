{ buildPythonPackage
, setuptools-scm
, pytestCheckHook
, git
, mercurial
, pip
, virtualenv
}:

<<<<<<< HEAD
buildPythonPackage {
  pname = "setuptools-scm-tests";
  inherit (setuptools-scm) version src;
  format = "other";

=======
buildPythonPackage rec {
  pname = "setuptools-scm-tests";
  inherit (setuptools-scm) version;
  format = "other";

  src = setuptools-scm.src;

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
