{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub
<<<<<<< HEAD
, pytestCheckHook
, pythonOlder
=======
, pytest-runner
, pytestCheckHook
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "token-bucket";
  version = "0.3.0";
  format = "setuptools";

<<<<<<< HEAD
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "falconry";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-dazqJRpC8FUHOhgKFzDnIl5CT2L74J2o2Hsm0IQf4Cg=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "'pytest-runner'" ""
  '';
=======
  src = fetchFromGitHub {
    owner = "falconry";
    repo = pname;
    rev = version;
    sha256 = "0a703y2d09kvv2l9vq7vc97l4pi2wwq1f2hq783mbw2238jymb3m";
  };

  nativeBuildInputs = [
    pytest-runner
  ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  nativeCheckInputs = [
    pytestCheckHook
  ];

  doCheck = !stdenv.isDarwin;

  meta = with lib; {
    description = "Token Bucket Implementation for Python Web Apps";
    homepage = "https://github.com/falconry/token-bucket";
<<<<<<< HEAD
    changelog = "https://github.com/falconry/token-bucket/releases/tag/${version}";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.asl20;
    maintainers = with maintainers; [ hexa ];
  };
}
