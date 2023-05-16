<<<<<<< HEAD
{ lib, stdenv, fetchurl, autoreconfHook, pkg-config, libX11, guile }:
=======
{ lib, stdenv, fetchurl, pkg-config, libX11, guile }:
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

stdenv.mkDerivation rec {
  pname = "xbindkeys";
  version = "1.8.7";
  src = fetchurl {
    url = "https://www.nongnu.org/xbindkeys/xbindkeys-${version}.tar.gz";
    sha256 = "1wl2vc5alisiwyk8m07y1ryq8w3ll9ym83j27g4apm4ixjl8d6x2";
  };

<<<<<<< HEAD
  nativeBuildInputs = [ autoreconfHook pkg-config ];
=======
  nativeBuildInputs = [ pkg-config ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  buildInputs = [ libX11 guile ];

  meta = {
    homepage = "https://www.nongnu.org/xbindkeys/xbindkeys.html";
    description = "Launch shell commands with your keyboard or your mouse under X Window";
    license = lib.licenses.gpl2Plus;
<<<<<<< HEAD
    maintainers = with lib.maintainers; [ viric ];
=======
    maintainers = with lib.maintainers; [viric];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    platforms = with lib.platforms; linux;
  };
}
