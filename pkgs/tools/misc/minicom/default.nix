{ stdenv, fetchurl, ncurses }:

stdenv.mkDerivation rec {
  name = "minicom-2.7";

  src = fetchurl {
    url = "http://alioth.debian.org/frs/download.php/file/3977/${name}.tar.gz";
    sha256 = "1x04m4k7c71j5cnhzpjrbz43dd96k4mpkd0l87v5skrgp1isdhws";
  };

  buildInputs = [ncurses];

  configureFlags = [ "--sysconfdir=/etc" "--enable-lock-dir=/var/lock" ];

  preConfigure =
    # Have `configure' assume that the lock directory exists.
    '' sed -i "configure" -e's/test -d \$UUCPLOCK/true/g'
    '';

  meta = {
    description = "Modem control and terminal emulation program";
    homepage = http://alioth.debian.org/projects/minicom/;

    longDescription =
      '' Minicom is a menu driven communications program.  It emulates ANSI
         and VT102 terminals.  It has a dialing directory and auto zmodem
         download.
      '';

    platforms = stdenv.lib.platforms.gnu;  # arbitrary choice
  };
}
