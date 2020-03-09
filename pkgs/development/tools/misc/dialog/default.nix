{ stdenv, fetchurl, ncurses
, withLibrary ? false, libtool
, unicodeSupport ? true
, enableShared ? !stdenv.isDarwin
}:

assert withLibrary -> libtool != null;
assert unicodeSupport -> ncurses.unicode && ncurses != null;

stdenv.mkDerivation rec {
  pname = "dialog";
  version = "1.3-20190211";

  src = fetchurl {
    urls = [
      "ftp://ftp.invisible-island.net/dialog/${pname}-${version}.tgz"
      "https://invisible-mirror.net/archives/dialog/${pname}-${version}.tgz"
    ];
    sha256 = "1lx0bvradzx1zl7znlrsnyljcs596r7wamkhyq37ikbxsy4y5h29";
  };

  buildInputs = [ ncurses ];

  configureFlags = [
    "--disable-rpath-hacks"
    (stdenv.lib.withFeature withLibrary "libtool")
    "--with-ncurses${stdenv.lib.optionalString unicodeSupport "w"}"
    "--with-libtool-opts=${stdenv.lib.optionalString enableShared "-shared"}"
  ];

  installTargets = [ "install${stdenv.lib.optionalString withLibrary "-full"}" ];

  meta = {
    homepage = https://invisible-island.net/dialog/dialog.html;
    description = "Display dialog boxes from shell";
    license = stdenv.lib.licenses.lgpl21Plus;
    maintainers = [ stdenv.lib.maintainers.spacefrogg ];
    platforms = stdenv.lib.platforms.all;
  };
}
