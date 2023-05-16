{ lib, stdenv, fetchFromGitHub
, imake, gccmakedep, libX11, libXext, libXScrnSaver, xorgproto
}:

<<<<<<< HEAD
stdenv.mkDerivation (finalAttrs: {
=======
stdenv.mkDerivation rec {
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  pname = "xautolock";
  version = "2.2-7-ga23dd5c";

  # This repository contains xautolock-2.2 plus various useful patches that
  # were collected from Debian, etc.
  src = fetchFromGitHub {
    owner = "peti";
    repo = "xautolock";
<<<<<<< HEAD
    rev = "v${finalAttrs.version}";
    hash = "sha256-T2zAbRqSTxRp9u6EdZmIZfVxaGveeZkJgjp1DWgORoI=";
=======
    rev = "v${version}";
    sha256 = "10j61rl0sx9sh84rjyfyddl73xb5i2cpb17fyrli8kwj39nw0v2g";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [ imake gccmakedep ];
  buildInputs = [ libX11 libXext libXScrnSaver xorgproto ];

  makeFlags = [
    "BINDIR=$(out)/bin"
    "MANPATH=$(out)/share/man"
  ];

  installTargets = [ "install" "install.man" ];

  meta = with lib; {
    description = "Launch a given program when your X session has been idle for a given time";
    homepage = "http://www.ibiblio.org/pub/linux/X11/screensavers";
    maintainers = with maintainers; [ peti ];
    platforms = platforms.linux;
    license = licenses.gpl2;
<<<<<<< HEAD
    mainProgram = "xautolock";
  };
})
=======
  };
}
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
