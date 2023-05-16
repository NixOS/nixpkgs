{ lib, fetchFromSourcehut, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "swayr";
<<<<<<< HEAD
  version = "0.27.0";
=======
  version = "0.25.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromSourcehut {
    owner = "~tsdh";
    repo = "swayr";
    rev = "swayr-${version}";
<<<<<<< HEAD
    sha256 = "sha256-FvlBpBBvmivrnHaKYPxmRAE+PCfTxWS+tYYAFjq8Q6I=";
  };

  cargoHash = "sha256-Ux0Tx5+manPNUUtiCBo7FCMrBYwwUggrdpitywQ7MPk=";
=======
    sha256 = "sha256-LaLliChsdsQePoRAxI7Sq5B68+uAtGuVrJKdTdva6cI=";
  };

  cargoHash = "sha256-D631vqlwaWaLkBxpDFEINAXVzbi7e2K9QiRfyKPW5+A=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  patches = [
    ./icon-paths.patch
  ];

  # don't build swayrbar
  buildAndTestSubdir = pname;

  preCheck = ''
    export HOME=$TMPDIR
  '';

<<<<<<< HEAD
  meta = {
    description = "A window switcher (and more) for sway";
    homepage = "https://git.sr.ht/~tsdh/swayr";
    license = lib.licenses.gpl3Plus;
    mainProgram = "swayr";
    maintainers = with lib.maintainers; [ artturin ];
    platforms = lib.platforms.linux;
=======
  meta = with lib; {
    description = "A window switcher (and more) for sway";
    homepage = "https://git.sr.ht/~tsdh/swayr";
    license = with licenses; [ gpl3Plus ];
    maintainers = with maintainers; [ artturin ];
    platforms = platforms.linux;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
