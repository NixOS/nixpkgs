{ stdenv, fetchurl, ncurses, pam ? null }:

stdenv.mkDerivation rec {
  name = "screen-4.3.1";

  src = fetchurl {
    url = "mirror://gnu/screen/${name}.tar.gz";
    sha256 = "0qwxd4axkgvxjigz9xs0kcv6qpfkrzr2gm43w9idx0z2mvw4jh7s";
  };

  preConfigure = ''
    configureFlags="--enable-telnet --enable-pam --infodir=$out/share/info --mandir=$out/share/man --with-sys-screenrc=/etc/screenrc --enable-colors256"
    sed -i -e "s|/usr/local|/non-existent|g" -e "s|/usr|/non-existent|g" configure Makefile.in */Makefile.in
  '';

  # TODO: remove when updating the version of screen. Only a patch for 4.3.1
  patches = stdenv.lib.optional stdenv.isDarwin (fetchurl {
    url = "http://savannah.gnu.org/file/screen-utmp.patch\?file_id=34815";
    sha256 = "192dsa8hm1zw8m638avzhwhnrddgizhyrwaxgwa96zr9vwai2nvc";
  });

  buildInputs = [ ncurses ] ++ stdenv.lib.optional stdenv.isLinux pam;

  doCheck = true;

  meta = {
    homepage = http://www.gnu.org/software/screen/;
    description = "A window manager that multiplexes a physical terminal";
    license = stdenv.lib.licenses.gpl2Plus;

    longDescription =
      '' GNU Screen is a full-screen window manager that multiplexes a physical
         terminal between several processes, typically interactive shells.
         Each virtual terminal provides the functions of the DEC VT100
         terminal and, in addition, several control functions from the ANSI
         X3.64 (ISO 6429) and ISO 2022 standards (e.g., insert/delete line
         and support for multiple character sets).  There is a scrollback
         history buffer for each virtual terminal and a copy-and-paste
         mechanism that allows the user to move text regions between windows.
         When screen is called, it creates a single window with a shell in it
         (or the specified command) and then gets out of your way so that you
         can use the program as you normally would.  Then, at any time, you
         can create new (full-screen) windows with other programs in them
         (including more shells), kill the current window, view a list of the
         active windows, turn output logging on and off, copy text between
         windows, view the scrollback history, switch between windows, etc.
         All windows run their programs completely independent of each other.
         Programs continue to run when their window is currently not visible
         and even when the whole screen session is detached from the users
         terminal.
      '';

    platforms = stdenv.lib.platforms.unix;
    maintainers = with stdenv.lib.maintainers; [ simons jgeerds ];
  };
}
