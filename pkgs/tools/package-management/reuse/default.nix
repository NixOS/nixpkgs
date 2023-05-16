{ lib, python3Packages, fetchFromGitHub }:

python3Packages.buildPythonApplication rec {
  pname = "reuse";
<<<<<<< HEAD
  version = "2.1.0";
=======
  version = "1.1.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "fsfe";
    repo = "reuse-tool";
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-MEQiuBxe/ctHlAnmLhQY4QH62uAcHb7CGfZz+iZCRSk=";
=======
    hash = "sha256-J+zQrokrAX5tRU/2RPPSaFDyfsACPHHQYbK5sO99CMs=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = with python3Packages; [
    poetry-core
  ];

  propagatedBuildInputs = with python3Packages; [
    binaryornot
    boolean-py
    debian
    jinja2
    license-expression
<<<<<<< HEAD
=======
    setuptools
    setuptools-scm
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  nativeCheckInputs = with python3Packages; [ pytestCheckHook ];

<<<<<<< HEAD
  disabledTestPaths = [
    # pytest wants to execute the actual source files for some reason, which fails with ImportPathMismatchError()
    "src/reuse"
  ];

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  meta = with lib; {
    description = "A tool for compliance with the REUSE Initiative recommendations";
    homepage = "https://github.com/fsfe/reuse-tool";
    license = with licenses; [ asl20 cc-by-sa-40 cc0 gpl3Plus ];
    maintainers = with maintainers; [ FlorianFranzen Luflosi ];
  };
}
