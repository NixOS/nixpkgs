{ lib, stdenv, fetchFromGitHub
, imake, gccmakedep, libX11, libXext, libXScrnSaver, xorgproto
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xautolock";
  version = "2.2-7-ga23dd5c";

  # This repository contains xautolock-2.2 plus various useful patches that
  # were collected from Debian, etc.
  src = fetchFromGitHub {
    owner = "peti";
    repo = "xautolock";
    rev = "v${finalAttrs.version}";
    hash = "sha256-T2zAbRqSTxRp9u6EdZmIZfVxaGveeZkJgjp1DWgORoI=";
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
    mainProgram = "xautolock";
  };
})
