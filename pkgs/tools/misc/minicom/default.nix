{ stdenv, fetchurl, ncurses }:

stdenv.mkDerivation rec {
  name = "minicom-2.4";

  src = fetchurl {
    url = "http://alioth.debian.org/frs/download.php/3195/${name}.tar.gz";
    sha256 = "0j0ayimh3389pciqs60fsfafn87p9gnmmmqz15xq9fkkn10g4ykb";
  };

  buildInputs = [ncurses];

  configureFlags = [ "--sysconfdir=/etc" "--enable-lock-dir=/var/lock" ];

  preConfigure =
    # Have `configure' assume that the lock directory exists.
    '' sed -i "configure" -e's/test -d \$UUCPLOCK/true/g'
    '';

  meta = {
    description = "Minicom, a modem control and terminal emulation program";
    homepage = http://alioth.debian.org/projects/minicom/;

    longDescription =
      '' Minicom is a menu driven communications program.  It emulates ANSI
         and VT102 terminals.  It has a dialing directory and auto zmodem
         download.
      '';

    platforms = stdenv.lib.platforms.gnu;  # arbitrary choice
  };
}
