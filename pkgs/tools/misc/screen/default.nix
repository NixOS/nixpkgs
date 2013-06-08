{ stdenv, fetchurl, ncurses, pam }:

stdenv.mkDerivation rec {
  name = "screen-4.0.3";

  src = fetchurl {
    url = "mirror://gnu/screen/${name}.tar.gz";
    sha256 = "0xvckv1ia5pjxk7fs4za6gz2njwmfd54sc464n8ab13096qxbw3q";
  };

  patches = [ ./screen-4.0.3-caption-colors.patch
              ./screen-4.0.3-long-term.patch ];

  preConfigure = ''
    configureFlags="--enable-telnet --enable-pam --infodir=$out/share/info --mandir=$out/share/man --with-sys-screenrc=/etc/screenrc"
    sed -i -e "s|/usr/local|/non-existent|g" -e "s|/usr|/non-existent|g" configure Makefile.in */Makefile.in
  '';

  buildInputs = [ ncurses pam ];

  doCheck = true;

  meta = {
    homepage = http://www.gnu.org/software/screen/;
    description = "GNU Screen, a window manager that multiplexes a physical terminal";

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

    license = stdenv.lib.licenses.gpl2Plus;

    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.ludo stdenv.lib.maintainers.simons ];
  };
}
