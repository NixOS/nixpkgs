<<<<<<< HEAD
{ lib, fetchFromGitHub, fetchpatch, python3Packages }:
=======
{ lib, fetchFromGitHub, python3Packages }:
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

python3Packages.buildPythonPackage rec {
  pname = "cc2538-bsl";
  version = "unstable-2022-08-03";
<<<<<<< HEAD
  format = "setuptools";

  src = fetchFromGitHub {
=======

  src = fetchFromGitHub rec {
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    owner = "JelmerT";
    repo = pname;
    rev = "538ea0deb99530e28fdf1b454e9c9d79d85a3970";
    hash = "sha256-fPY12kValxbJORi9xNyxzwkGpD9F9u3M1+aa9IlSiaE=";
  };

<<<<<<< HEAD
  patches = [
    # https://github.com/JelmerT/cc2538-bsl/pull/138
    (fetchpatch {
      name = "clean-up-install-dependencies.patch";
      url = "https://github.com/JelmerT/cc2538-bsl/commit/bf842adf8e99a9eb8528579e5b85e59ee23be08d.patch";
      hash = "sha256-XKQ0kfl8yFrSF5RosHY9OvJR18Fh0dmAN1FlfZ024ME=";
    })
  ];

  env.SETUPTOOLS_SCM_PRETEND_VERSION = "0.1.dev0+g${lib.substring 0 7 src.rev}";

  nativeBuildInputs = with python3Packages; [
    setuptools-scm
  ];
=======
  nativeBuildInputs = [ python3Packages.setuptools-scm ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  propagatedBuildInputs = with python3Packages; [
    intelhex
    pyserial
    python-magic
  ];

<<<<<<< HEAD
  nativeCheckInputs = with python3Packages; [
    pytestCheckHook
    scripttest
  ];
=======
  env.SETUPTOOLS_SCM_PRETEND_VERSION = "0.1.dev0+g${lib.substring 0 7 src.rev}";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  postInstall = ''
    # Remove .py from binary
    mv $out/bin/cc2538-bsl.py $out/bin/cc2538-bsl
  '';

  meta = with lib; {
    homepage = "https://github.com/JelmerT/cc2538-bsl";
    description = "Flash TI SimpleLink chips (CC2538, CC13xx, CC26xx) over serial";
    license = licenses.bsd3;
    maintainers = with maintainers; [ lorenz ];
  };
}

