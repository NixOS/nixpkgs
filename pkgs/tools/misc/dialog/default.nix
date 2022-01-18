{ lib
, stdenv
, fetchurl
, ncurses
, withLibrary ? false, libtool
, unicodeSupport ? true
, enableShared ? !stdenv.isDarwin
}:

assert withLibrary -> libtool != null;
assert unicodeSupport -> ncurses.unicodeSupport && ncurses != null;

stdenv.mkDerivation rec {
  pname = "dialog";
  version = "1.3-20211214";

  src = fetchurl {
    url = "ftp://ftp.invisible-island.net/dialog/${pname}-${version}.tgz";
    hash = "sha256-zCll4FxqjDcHCza1ZBTqpWDfjYfyzqIXWeKJUOmyeks=";
  };

  buildInputs = [
    ncurses
  ];

  configureFlags = [
    "--disable-rpath-hacks"
    (lib.withFeature withLibrary "libtool")
    "--with-ncurses${lib.optionalString unicodeSupport "w"}"
    "--with-libtool-opts=${lib.optionalString enableShared "-shared"}"
  ];

  installTargets = [
    "install${lib.optionalString withLibrary "-full"}"
  ];

  meta = with lib; {
    homepage = "https://invisible-island.net/dialog/dialog.html";
    description = "Display dialog boxes from shell";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ AndersonTorres spacefrogg ];
    inherit (ncurses.meta) platforms;
  };
}
