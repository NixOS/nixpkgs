{ stdenv, fetchurl, ncurses }:

stdenv.mkDerivation rec {
  name = "minicom-2.6.2";

  src = fetchurl {
    url = "http://alioth.debian.org/frs/download.php/file/3869/${name}.tar.gz";
    sha256 = "0s4ibk8scspm8a0raf5s4zgp9b82c4bn529rir9abzqlg5gj3kzk";
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
