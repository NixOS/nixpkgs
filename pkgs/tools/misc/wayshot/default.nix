{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "wayshot";
<<<<<<< HEAD
  version = "1.3.0";
=======
  version = "1.2.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "waycrate";
    repo = pname;
    rev = version;
<<<<<<< HEAD
    hash = "sha256-WN1qlV6vpIn0uNiE+rXeQTMscNYqkgFytVBc6gJzvyU=";
  };

  cargoHash = "sha256-Hfgr+wWC5zUdHhFMwOBt57h2r94OpdJ1MQpckhYgKQQ=";
=======
    hash = "sha256-/uZ98ICdPTilUD3vBEbJ4AxGWY1xIbkK6O+bkhqIUKA=";
  };

  cargoHash = "sha256-j/gSrXY5n/zW3IogHewyrupTKtEm5EtOzfOzglyTP9A=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "A native, blazing-fast screenshot tool for wlroots based compositors such as sway and river";
    homepage = "https://github.com/waycrate/wayshot";
    license = licenses.bsd2;
    maintainers = [ maintainers.dit7ya ];
    platforms = platforms.linux;
<<<<<<< HEAD
    mainProgram = "wayshot";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
