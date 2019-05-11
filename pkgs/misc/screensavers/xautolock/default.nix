{ stdenv, fetchFromGitHub, xlibsWrapper
, imake, gccmakedep, libXScrnSaver, xorgproto
}:

stdenv.mkDerivation rec {
  name = "xautolock-${version}";
  version = "2.2-6-ge68d0ed";

  # This repository contains xautolock-2.2 plus various useful patches that
  # were collected from Debian, etc.
  src = fetchFromGitHub {
    owner = "peti";
    repo = "xautolock";
    rev = "v${version}";
    sha256 = "1131ki6zwk94s8j6zqywf8r5kanx3nrjm692rxh8pcz4hv9qp1mz";
  };

  nativeBuildInputs = [ imake gccmakedep ];
  buildInputs = [ xlibsWrapper libXScrnSaver xorgproto ];

  makeFlags = [
    "BINDIR=$(out)/bin"
    "MANPATH=$(out)/share/man"
  ];

  installTargets = "install install.man";

  meta = with stdenv.lib; {
    description = "Launch a given program when your X session has been idle for a given time.";
    homepage = "http://www.ibiblio.org/pub/linux/X11/screensavers";
    maintainers = with maintainers; [ garbas peti ];
    platforms = platforms.linux;
    license = licenses.gpl2;
  };
}
