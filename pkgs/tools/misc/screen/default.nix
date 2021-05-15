{ lib, stdenv, fetchurl, fetchpatch, ncurses, utmp, pam ? null }:

stdenv.mkDerivation rec {
  pname = "screen";
  version = "4.8.0";

  src = fetchurl {
    url = "mirror://gnu/screen/${pname}-${version}.tar.gz";
    sha256 = "18ascpjzsy70h6hk7wpg8zmzjwgdyrdr7c6z4pg5z4l9hhyv24bf";
  };

  configureFlags= [
    "--enable-telnet"
    "--enable-pam"
    "--with-sys-screenrc=/etc/screenrc"
    "--enable-colors256"
  ];

  patches = [
    (fetchpatch {
      # Fixes denial of services in encoding.c, remove > 4.8.0
      name = "CVE-2021-26937.patch";
      url = "https://salsa.debian.org/debian/screen/-/raw/master/debian/patches/99_CVE-2021-26937.patch";
      sha256 = "05f3p1c7s83nccwkhmavjzgaysxnvq41c7jffs31ra65kcpabqy0";
    })
  ] ++ lib.optional stdenv.hostPlatform.isMusl
    (fetchpatch {
      url = "https://gist.githubusercontent.com/yujinakayama/4608863/raw/76b9f89af5e5a2e97d9a0f36aac989fb56cf1447/gistfile1.diff";
      sha256 = "0f9bf83p8zdxaa1pr75jyf5g8xr3r8kv7cyzzbpraa1q4j15ss1p";
      stripLen = 1;
    });

  postPatch = lib.optionalString (stdenv.buildPlatform != stdenv.hostPlatform)
    # XXX: Awful hack to allow cross-compilation.
    '' sed -i ./configure \
           -e 's/^as_fn_error .. \("cannot run test program while cross compiling\)/$as_echo \1/g'
    ''; # "

  buildInputs = [ ncurses ] ++ lib.optional stdenv.isLinux pam
                            ++ lib.optional stdenv.isDarwin utmp;

  doCheck = true;

  meta = with lib; {
    homepage = "https://www.gnu.org/software/screen/";
    description = "A window manager that multiplexes a physical terminal";
    license = licenses.gpl2Plus;

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

    platforms = platforms.unix;
    maintainers = with maintainers; [ peti vrthra ];
  };
}
