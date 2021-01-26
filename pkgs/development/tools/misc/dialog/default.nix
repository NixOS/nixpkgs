{ lib, stdenv, fetchurl
, ncurses
, withLibrary ? false, libtool
, unicodeSupport ? true
, enableShared ? !stdenv.isDarwin
}:

assert withLibrary -> libtool != null;
assert unicodeSupport -> ncurses.unicode && ncurses != null;

stdenv.mkDerivation rec {
  pname = "dialog";
  version = "1.3-20201126";

  src = fetchurl {
    urls = [
      "ftp://ftp.invisible-island.net/dialog/${pname}-${version}.tgz"
      "https://invisible-mirror.net/archives/dialog/${pname}-${version}.tgz"
    ];
    sha256 = "sha256-ySM6bI6jOlniN45RRq4r0TtRl0TP22R690IK2sWtOGY=";
  };

  buildInputs = [ ncurses ];

  configureFlags = [
    "--disable-rpath-hacks"
    (lib.withFeature withLibrary "libtool")
    "--with-ncurses${lib.optionalString unicodeSupport "w"}"
    "--with-libtool-opts=${lib.optionalString enableShared "-shared"}"
  ];

  installTargets = [ "install${lib.optionalString withLibrary "-full"}" ];

  meta = with lib; {
    homepage = "https://invisible-island.net/dialog/dialog.html";
    description = "Display dialog boxes from shell";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ AndersonTorres spacefrogg ];
    platforms = ncurses.meta.platforms;
  };
}
