{
  lib,
  stdenv,
  fetchurl,
  autoreconfHook,
  ncurses,
  libxcrypt,
  utmp,
  pam ? null,
}:

stdenv.mkDerivation rec {
  pname = "screen";
  version = "5.0.0";

  src = fetchurl {
    url = "mirror://gnu/screen/screen-${version}.tar.gz";
    hash = "sha256-8Eo50AoOXHyGpVM4gIkDCCrV301z3xov00JZdq7ZSXE=";
  };

  configureFlags = [
    "--enable-telnet"
    "--enable-pam"
    "--with-sys-screenrc=/etc/screenrc"
    "--enable-colors256"
    "--enable-rxvt_osc"
  ];

  # We need _GNU_SOURCE so that mallocmock_reset() is defined: https://savannah.gnu.org/bugs/?66416
  NIX_CFLAGS_COMPILE = lib.optionalString (stdenv.cc.isGNU) "-D_GNU_SOURCE=1 -Wno-int-conversion -Wno-incompatible-pointer-types";

  nativeBuildInputs = [
    autoreconfHook
  ];
  buildInputs = [
    ncurses
    libxcrypt
    pam
  ] ++ lib.optional stdenv.hostPlatform.isDarwin utmp;

  # The test suite seems to have some glibc malloc hooks that don't exist/link on macOS
  doCheck = !stdenv.hostPlatform.isDarwin;

  meta = with lib; {
    homepage = "https://www.gnu.org/software/screen/";
    description = "Window manager that multiplexes a physical terminal";
    license = licenses.gpl3Plus;

    longDescription = ''
      GNU Screen is a full-screen window manager that multiplexes a physical
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

    platforms = platforms.unix;
    maintainers = [ ];
  };
}
