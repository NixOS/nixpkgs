{ lib
, stdenv
, fetchurl
, libtool
, ncurses
, enableShared ? !stdenv.isDarwin
, unicodeSupport ? true
, withLibrary ? false
}:

assert unicodeSupport -> ncurses.unicodeSupport;

stdenv.mkDerivation (finalAttrs: {
  pname = "dialog";
  version = "1.3-20230209";

  src = fetchurl {
    url = "https://invisible-island.net/archives/dialog/dialog-${finalAttrs.version}.tgz";
    hash = "sha256-DCYoIwUmS+IhfzNfN5j0ix3OPPEsWgdr8jHK33em1qg=";
  };

  nativeBuildInputs = lib.optional withLibrary libtool;

  buildInputs = [
    ncurses
  ];

  strictDeps = true;

  configureFlags = [
    "--disable-rpath-hacks"
    "--${if withLibrary then "with" else "without"}-libtool"
    "--with-libtool-opts=${lib.optionalString enableShared "-shared"}"
    "--with-ncurses${lib.optionalString unicodeSupport "w"}"
  ];

  installTargets = [
    "install${lib.optionalString withLibrary "-full"}"
  ];

  meta = {
    homepage = "https://invisible-island.net/dialog/dialog.html";
    description = "Display dialog boxes from shell";
    license = lib.licenses.lgpl21Plus;
    maintainers = with lib.maintainers; [ AndersonTorres spacefrogg ];
    inherit (ncurses.meta) platforms;
  };
})
