{ fetchurl, fetchpatch, stdenv, lib, pkgconfig
, libgpgerror, libassuan, libcap ? null, libsecret ? null, ncurses ? null, gtk2 ? null, gcr ? null, qt4 ? null
}:

let
  mkFlag = pfxTrue: pfxFalse: cond: name: "--${if cond then pfxTrue else pfxFalse}-${name}";
  mkEnable = mkFlag "enable" "disable";
  mkWith = mkFlag "with" "without";
in
with stdenv.lib;
stdenv.mkDerivation rec {
  name = "pinentry-1.0.0";

  src = fetchurl {
    url = "mirror://gnupg/pinentry/${name}.tar.bz2";
    sha256 = "0ni7g4plq6x78p32al7m8h2zsakvg1rhfz0qbc3kdc7yq7nw4whn";
  };

  buildInputs = [ libgpgerror libassuan libcap libsecret gtk2 gcr ncurses qt4 ];

  prePatch = ''
    substituteInPlace pinentry/pinentry-curses.c --replace ncursesw ncurses
  '';

  patches = lib.optionals (gtk2 != null) [
    (fetchpatch {
       url = https://salsa.debian.org/debian/pinentry/raw/a2d5f644e6fd439dd4b7dcc1b4a5f983471743d4/debian/patches/0006-gtk2-Fix-a-problem-with-fvwm.patch;
       sha256 = "1w3y4brqp74hy3fbfxqnqp6jf985bd6667ivy1crz50r3z9zsy09";
  })(fetchpatch {
       url = https://anonscm.debian.org/cgit/pkg-gnupg/pinentry.git/plain/debian/patches/0007-gtk2-When-X11-input-grabbing-fails-try-again-over-0..patch;
       sha256 = "046jy7k0n7fj74s5w1h6sq1ljg8y77i0xwi301kv53bhsp0xsirx";
  })];

  # configure cannot find moc on its own
  preConfigure = stdenv.lib.optionalString (qt4 != null) ''
    export QTDIR="${qt4}"
    export MOC="${qt4}/bin/moc"
  '';

  configureFlags = [
    (mkWith   (libcap != null)    "libcap")
    (mkEnable (libsecret != null) "libsecret")
    (mkEnable (ncurses != null)   "pinentry-curses")
    (mkEnable true                "pinentry-tty")
    (mkEnable (gtk2 != null)      "pinentry-gtk2")
    (mkEnable (gcr != null)       "pinentry-gnome3")
    (mkEnable (qt4 != null)       "pinentry-qt")
  ];

  nativeBuildInputs = [ pkgconfig ];

  meta = {
    homepage = http://gnupg.org/aegypten2/;
    description = "GnuPG's interface to passphrase input";
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = stdenv.lib.platforms.all;
    longDescription = ''
      Pinentry provides a console and (optional) GTK+ and Qt GUIs allowing users
      to enter a passphrase when `gpg' or `gpg2' is run and needs it.
    '';
    maintainers = [ stdenv.lib.maintainers.ttuegel ];
  };
}
