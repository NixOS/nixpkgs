{ fetchurl, fetchpatch, stdenv, lib, pkgconfig, autoreconfHook
, libgpgerror, libassuan
, libcap ? null, libsecret ? null, ncurses ? null, gtk2 ? null, gcr ? null
, qt4 ? null, qt5 ? null
, enableEmacs ? false
}:

assert qt5 != null -> qt4 == null;
assert qt4 != null -> qt5 == null;

let
  mkDerivation =
    if qt5 != null
      then qt5.mkDerivation
      else stdenv.mkDerivation;
in

mkDerivation rec {
  name = "pinentry-1.1.0";

  src = fetchurl {
    url = "mirror://gnupg/pinentry/${name}.tar.bz2";
    sha256 = "0w35ypl960pczg5kp6km3dyr000m1hf0vpwwlh72jjkjza36c1v8";
  };

  nativeBuildInputs = [ pkgconfig autoreconfHook ];
  buildInputs =
    [ libgpgerror libassuan libcap libsecret gtk2 gcr ncurses qt4 ]
    ++ stdenv.lib.optional (qt5 != null) qt5.qtbase;

  prePatch = ''
    substituteInPlace pinentry/pinentry-curses.c --replace ncursesw ncurses
  '';

  patches = [
    ./autoconf-ar.patch
  ] ++ lib.optionals (gtk2 != null) [
    (fetchpatch {
      url = "https://salsa.debian.org/debian/pinentry/raw/debian/1.1.0-1/debian/patches/"
          + "0007-gtk2-When-X11-input-grabbing-fails-try-again-over-0..patch";
      sha256 = "15r1axby3fdlzz9wg5zx7miv7gqx2jy4immaw4xmmw5skiifnhfd";
    })
  ];

  configureFlags = [
    (stdenv.lib.withFeature   (libcap != null)    "libcap")
    (stdenv.lib.enableFeature (libsecret != null) "libsecret")
    (stdenv.lib.enableFeature (ncurses != null)   "pinentry-curses")
    (stdenv.lib.enableFeature true                "pinentry-tty")
    (stdenv.lib.enableFeature enableEmacs         "pinentry-emacs")
    (stdenv.lib.enableFeature (gtk2 != null)      "pinentry-gtk2")
    (stdenv.lib.enableFeature (gcr != null)       "pinentry-gnome3")
    (stdenv.lib.enableFeature (qt4 != null || qt5 != null) "pinentry-qt")

    "--with-libassuan-prefix=${libassuan.dev}"
    "--with-libgpg-error-prefix=${libgpgerror.dev}"
  ];

  meta = with stdenv.lib; {
    homepage = http://gnupg.org/aegypten2/;
    description = "GnuPG’s interface to passphrase input";
    license = licenses.gpl2Plus;
    platforms = platforms.all;
    longDescription = ''
      Pinentry provides a console and (optional) GTK and Qt GUIs allowing users
      to enter a passphrase when `gpg' or `gpg2' is run and needs it.
    '';
    maintainers = [ maintainers.ttuegel ];
  };
}
