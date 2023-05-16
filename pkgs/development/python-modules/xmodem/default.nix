{ lib, buildPythonPackage, fetchFromGitHub, pytest, which, lrzsz }:

buildPythonPackage rec {
  pname = "xmodem";
<<<<<<< HEAD
  version = "0.4.7";
=======
  version = "0.4.6";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "tehmaze";
    repo = "xmodem";
<<<<<<< HEAD
    rev = "refs/tags/${version}";
    sha256 = "sha256-kwPA/lYiv6IJSKGRuH13tBofZwp19vebwQniHK7A/i8=";
=======
    rev = version;
    sha256 = "1xx7wd8bnswxa1fv3bfim2gcamii79k7qmwg7dbxbjvrhbcjjc0l";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeCheckInputs = [ pytest which lrzsz ];

  checkPhase = ''
    pytest
  '';

  meta = with lib; {
    description = "Pure python implementation of the XMODEM protocol";
    maintainers = with maintainers; [ emantor ];
    homepage = "https://github.com/tehmaze/xmodem";
    license = licenses.mit;
  };
}
