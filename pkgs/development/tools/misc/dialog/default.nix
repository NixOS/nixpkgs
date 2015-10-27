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
  version = "1.2-20150920";

  src = fetchurl {
    url = "ftp://invisible-island.net/dialog/${name}.tgz";
    sha256 = "01ccd585c241nkj02n0zdbx8jqhylgcfpcmmshynh0c7fv2ixrn4";
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
