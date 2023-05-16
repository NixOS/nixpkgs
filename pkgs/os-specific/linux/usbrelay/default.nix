{ stdenv, lib, fetchFromGitHub, hidapi, installShellFiles }:
<<<<<<< HEAD
stdenv.mkDerivation (finalAttrs: {
  pname = "usbrelay";
  version = "1.2";
=======
stdenv.mkDerivation rec {
  pname = "usbrelay";
  version = "1.0.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "darrylb123";
    repo = "usbrelay";
<<<<<<< HEAD
    rev = finalAttrs.version;
    sha256 = "sha256-oJyHzbXOBKxLmPFZMS2jLF80frkiKjPJ89UwkenjIzs=";
=======
    rev = version;
    sha256 = "sha256-2elDrO+WaaRYdTrG40Ez00qSsNVQjXE6GdOJbWPfugE=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    installShellFiles
  ];

  buildInputs = [
    hidapi
  ];

  makeFlags = [
<<<<<<< HEAD
    "DIR_VERSION=${finalAttrs.version}"
    "PREFIX=${placeholder "out"}"
    "LDCONFIG=${stdenv.cc.libc.bin}/bin/ldconfig"
=======
    "DIR_VERSION=${version}"
    "PREFIX=${placeholder "out"}"
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  postInstall = ''
    installManPage usbrelay.1
  '';

  meta = with lib; {
    description = "Tool to control USB HID relays";
    homepage = "https://github.com/darrylb123/usbrelay";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ wentasah ];
    platforms = platforms.linux;
  };
<<<<<<< HEAD
})
=======
}
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
