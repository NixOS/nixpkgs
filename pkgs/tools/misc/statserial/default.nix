{ lib, stdenv, fetchurl, ncurses, glibc }:

stdenv.mkDerivation rec {
  pname = "statserial";
  version = "1.1";

  src = fetchurl {
    url = "http://www.ibiblio.org/pub/Linux/system/serial/${pname}-${version}.tar.gz";
    sha256 = "0rrrmxfba5yn836zlgmr8g9xnrpash7cjs7lk2m44ac50vakpks0";
  };

  postPatch = ''
    substituteInPlace Makefile \
      --replace '-lcurses' '-lncurses'

    substituteInPlace Makefile \
      --replace 'LDFLAGS = -s -N' '#LDFLAGS = -s -N'
  '';

  buildInputs = [ ncurses glibc ];

  installPhase = ''
  mkdir -p $out/bin
  cp statserial $out/bin

  mkdir -p $out/share/man/man1
  cp statserial.1 $out/share/man/man1
  '';

  meta = with lib; {
    homepage = "https://sites.google.com/site/tranter/software";
    description = "Display serial port modem status lines";
    license = licenses.gpl2Plus;

    longDescription =
      '' Statserial displays a table of the signals on a standard 9-pin or
      25-pin serial port, and indicates the status of the handshaking lines. It
      can be useful for debugging problems with serial ports or modems.
      '';

    platforms = platforms.unix;
    maintainers = with maintainers; [ rps ];
    mainProgram = "statserial";
  };
}
