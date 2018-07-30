{ stdenv, fetchurl, ncurses
, withLibrary ? false, libtool
, unicodeSupport ? true
}:

let optStr = stdenv.lib.optionalString;
    buildShared = !stdenv.isDarwin;
in

assert withLibrary -> libtool != null;
assert unicodeSupport -> ncurses.unicode && ncurses != null;

stdenv.mkDerivation rec {
  name = "dialog-${version}";
  version = "1.3-20180621";

  src = fetchurl {
    urls = [
      "ftp://ftp.invisible-island.net/dialog/${name}.tgz"
      "https://invisible-mirror.net/archives/dialog/${name}.tgz"
    ];
    sha256 = "0yjqczlf64yppgvk4i6s0jm06mdr0mb5m6sj39nf891dnbi5jj2a";
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
