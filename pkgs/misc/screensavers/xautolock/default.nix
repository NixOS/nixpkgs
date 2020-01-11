{ stdenv, fetchFromGitHub, xlibsWrapper
, imake, gccmakedep, libXScrnSaver, xorgproto
}:

stdenv.mkDerivation rec {
  pname = "xautolock";
  version = "2.2-7-ga23dd5c";

  # This repository contains xautolock-2.2 plus various useful patches that
  # were collected from Debian, etc.
  src = fetchFromGitHub {
    owner = "peti";
    repo = "xautolock";
    rev = "v${version}";
    sha256 = "10j61rl0sx9sh84rjyfyddl73xb5i2cpb17fyrli8kwj39nw0v2g";
  };

  nativeBuildInputs = [ imake gccmakedep ];
  buildInputs = [ xlibsWrapper libXScrnSaver xorgproto ];

  makeFlags = [
    "BINDIR=$(out)/bin"
    "MANPATH=$(out)/share/man"
  ];

  installTargets = [ "install" "install.man" ];

  meta = with stdenv.lib; {
    description = "Launch a given program when your X session has been idle for a given time.";
    homepage = "http://www.ibiblio.org/pub/linux/X11/screensavers";
    maintainers = with maintainers; [ peti ];
    platforms = platforms.linux;
    license = licenses.gpl2;
  };
}
