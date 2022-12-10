{ lib
, stdenv
, fetchurl
, libtool
, ncurses
, withLibrary ? false
, unicodeSupport ? true
, enableShared ? !stdenv.isDarwin
}:

assert withLibrary -> libtool != null;
assert unicodeSupport -> ncurses != null && ncurses.unicodeSupport;

stdenv.mkDerivation (finalAttrs: {
  pname = "dialog";
  version = "1.3-20220728";

  src = fetchurl {
    url = "ftp://ftp.invisible-island.net/dialog/dialog-${finalAttrs.version}.tgz";
    hash = "sha256-VEGJc9VZpGGwBpX6/mjfYvK8c9UGtDaCHXfKPfRUGQs=";
  };

  buildInputs = [
    ncurses
  ];

  configureFlags = [
    "--disable-rpath-hacks"
    "--${if withLibrary then "with" else "without"}-libtool"
    "--with-libtool-opts=${lib.optionalString enableShared "-shared"}"
    "--with-ncurses${lib.optionalString unicodeSupport "w"}"
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
})
