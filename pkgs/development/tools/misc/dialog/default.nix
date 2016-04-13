{ stdenv, fetchurl, ncurses, gettext
, withLibrary ? false, libtool
, unicodeSupport ? true
}:

let optional = stdenv.lib.optional;
    optStr = stdenv.lib.optionalString;
    buildShared = !stdenv.isDarwin;
in

assert withLibrary -> libtool != null;
assert unicodeSupport -> ncurses.unicode && ncurses != null;

stdenv.mkDerivation rec {
  name = "dialog-${version}";
  version = "1.3-20160209";

  src = fetchurl {
    url = "ftp://invisible-island.net/dialog/${name}.tgz";
    sha256 = "11rzh14xy9s99gxdi5i7fgmgihjqsv0ls0ksavkmip2y37rgf503";
  };

  buildInputs = [ ncurses ];

  configureFlags = ''
    --disable-rpath-hacks
    ${optStr withLibrary "--with-libtool"}
    --with-libtool-opts=${optStr buildShared "-shared"}
    --with-ncurses${optStr unicodeSupport "w"}
  '';

  installTargets = "install${optStr withLibrary "-full"}";

  meta = {
    homepage = http://invisible-island.net/dialog/dialog.html;
    description = "Display dialog boxes from shell";
    license = stdenv.lib.licenses.lgpl21Plus;
    maintainers = [ stdenv.lib.maintainers.spacefrogg ];
    platforms = stdenv.lib.platforms.all;
  };
}
