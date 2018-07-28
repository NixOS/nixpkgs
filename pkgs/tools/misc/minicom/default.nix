{ stdenv, fetchurl, autoreconfHook, pkgconfig
, ncurses, libiconv }:

stdenv.mkDerivation rec {
  name = "minicom-2.7.1";

  src = fetchurl {
    url    = "https://alioth.debian.org/frs/download.php/latestfile/3/${name}.tar.gz";
    sha256 = "1wa1l36fa4npd21xa9nz60yrqwkk5cq713fa3p5v0zk7g9mq6bsk";
  };

  buildInputs = [ ncurses ] ++ stdenv.lib.optional stdenv.isDarwin libiconv;

  nativeBuildInputs = [ autoreconfHook pkgconfig ];

  enableParallelBuilding = true;

  configureFlags = [
    "--sysconfdir=/etc"
    "--enable-lock-dir=/var/lock"
  ];

  patches = [ ./xminicom_terminal_paths.patch ];

  preConfigure = ''
    # Have `configure' assume that the lock directory exists.
    substituteInPlace configure \
      --replace 'test -d $UUCPLOCK' true

    substituteInPlace src/rwconf.c \
      --replace /usr/bin/ascii-xfr $out/bin/ascii-xfr
  '';

  meta = with stdenv.lib; {
    description = "Modem control and terminal emulation program";
    homepage = https://alioth.debian.org/projects/minicom/;
    license = licenses.gpl2;
    longDescription = ''
      Minicom is a menu driven communications program.  It emulates ANSI
      and VT102 terminals.  It has a dialing directory and auto zmodem
      download.
    '';
    maintainers = with maintainers; [ peterhoeg ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
