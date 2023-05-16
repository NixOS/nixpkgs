{ lib
, crystal
, fetchFromGitHub
}:

crystal.buildCrystalPackage rec {
  pname = "blahaj";
<<<<<<< HEAD
  version = "2.1.0";
=======
  version = "2.0.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "GeopJr";
    repo = "BLAHAJ";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-rX6isAIlpNDBOGLmtvRXmqY90ByFfXeYI0HAAPIMXf8=";
=======
    hash = "sha256-g38a3mUt2bkwFH/Mwr2D3zEZczM/gdWObUOeeIJGHZ4=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  meta = with lib; {
    description = "Gay sharks at your local terminal - lolcat-like CLI tool";
    homepage = "https://blahaj.queer.software";
    license = licenses.bsd2;
<<<<<<< HEAD
    maintainers = with maintainers; [ aleksana cafkafk ];
=======
    maintainers = with maintainers; [ aleksana ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
