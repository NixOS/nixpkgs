{ lib, python, buildPythonPackage, fetchFromGitHub }:

buildPythonPackage rec {
  pname = "simplefix";
<<<<<<< HEAD
  version = "1.0.16";
=======
  version = "1.0.15";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    repo = "simplefix";
    owner = "da4089";
<<<<<<< HEAD
    rev = "refs/tags/v${version}";
    hash = "sha256-dkwmWCOeTAoeSY8+1wg7RWX/d57JWc8bGagzrEPMAIU=";
=======
    rev = "v${version}";
    hash = "sha256-GQHMotxNRuRv6zXhrD02T+aFgfYe3RnvUGADsBeSPbA=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  checkPhase = ''
    cd test
    ${python.interpreter} -m unittest all
  '';

  meta = with lib; {
    description = "Simple FIX Protocol implementation for Python";
    homepage = "https://github.com/da4089/simplefix";
    license = licenses.mit;
    maintainers = with maintainers; [ catern ];
  };
}
