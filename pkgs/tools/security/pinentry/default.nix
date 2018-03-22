{ fetchurl, fetchpatch, stdenv, lib, pkgconfig
, libgpgerror, libassuan, libcap ? null, libsecret ? null, ncurses ? null, gtk2 ? null, gcr ? null, qt ? null
}:

let
  mkFlag = pfxTrue: pfxFalse: cond: name: "--${if cond then pfxTrue else pfxFalse}-${name}";
  mkEnable = mkFlag "enable" "disable";
  mkWith = mkFlag "with" "without";
in
stdenv.mkDerivation rec {
  name = "pinentry-1.1.0";

  src = fetchurl {
    url = "mirror://gnupg/pinentry/${name}.tar.bz2";
    sha256 = "0w35ypl960pczg5kp6km3dyr000m1hf0vpwwlh72jjkjza36c1v8";
  };

  buildInputs = [ libgpgerror libassuan libcap libsecret gtk2 gcr ncurses qt ];

  prePatch = ''
    substituteInPlace pinentry/pinentry-curses.c --replace ncursesw ncurses
  '';

  patches = lib.optionals (gtk2 != null) [
    (fetchpatch {
      url = https://anonscm.debian.org/cgit/pkg-gnupg/pinentry.git/plain/debian/patches/0007-gtk2-When-X11-input-grabbing-fails-try-again-over-0..patch;
      sha256 = "15r1axby3fdlzz9wg5zx7miv7gqx2jy4immaw4xmmw5skiifnhfd";
    })
  ];

  configureFlags = [
    (mkWith   (libcap != null)    "libcap")
    (mkEnable (libsecret != null) "libsecret")
    (mkEnable (ncurses != null)   "pinentry-curses")
    (mkEnable true                "pinentry-tty")
    (mkEnable (gtk2 != null)      "pinentry-gtk2")
    (mkEnable (gcr != null)       "pinentry-gnome3")
    (mkEnable (qt != null)        "pinentry-qt")
  ];

  nativeBuildInputs = [ pkgconfig ];

  meta = with stdenv.lib; {
    homepage = http://gnupg.org/aegypten2/;
    description = "GnuPG’s interface to passphrase input";
    license = licenses.gpl2Plus;
    platforms = platforms.all;
    longDescription = ''
      Pinentry provides a console and (optional) GTK+ and Qt GUIs allowing users
      to enter a passphrase when `gpg' or `gpg2' is run and needs it.
    '';
    maintainers = [ maintainers.ttuegel ];
  };
}
