{ lib, stdenv
, buildPythonPackage
, fetchFromGitHub
, setuptools
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "Send2Trash";
<<<<<<< HEAD
  version = "1.8.2";
=======
  version = "1.8.1b0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "hsoft";
    repo = "send2trash";
    rev = "refs/tags/${version}";
<<<<<<< HEAD
    hash = "sha256-p0Pd9g+nLoT+oruthwjBn2E9rznvcx35VmzOAce2iTY=";
  };

=======
    hash = "sha256-kDUEfyMTk8CXSxTEi7E6kl09ohnWHeaoif+EIaIJh9Q=";
  };

  postPatch = ''
    # Confuses setuptools validation
    # setuptools.extern.packaging.requirements.InvalidRequirement: One of the parsed requirements in `extras_require[win32]` looks like a valid environment marker: 'sys_platform == "win32"'
    sed -i '/win32 =/d' setup.cfg

    # setuptools.extern.packaging.requirements.InvalidRequirement: One of the parsed requirements in `extras_require[objc]` looks like a valid environment marker: 'sys_platform == "darwin"'
    sed -i '/objc =/d' setup.cfg
  '';

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  nativeBuildInputs = [
    setuptools
  ];

  doCheck = !stdenv.isDarwin;

  preCheck = ''
    export HOME=$TMPDIR
  '';

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    description = "Send file to trash natively under macOS, Windows and Linux";
    homepage = "https://github.com/hsoft/send2trash";
    changelog = "https://github.com/arsenetar/send2trash/blob/${version}/CHANGES.rst";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
