{ lib
, stdenv
, fetchurl
, libtool
, ncurses
<<<<<<< HEAD
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

=======
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

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  buildInputs = [
    ncurses
  ];

<<<<<<< HEAD
  strictDeps = true;

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  configureFlags = [
    "--disable-rpath-hacks"
    "--${if withLibrary then "with" else "without"}-libtool"
    "--with-libtool-opts=${lib.optionalString enableShared "-shared"}"
    "--with-ncurses${lib.optionalString unicodeSupport "w"}"
  ];

  installTargets = [
    "install${lib.optionalString withLibrary "-full"}"
  ];

<<<<<<< HEAD
  meta = {
    homepage = "https://invisible-island.net/dialog/dialog.html";
    description = "Display dialog boxes from shell";
    license = lib.licenses.lgpl21Plus;
    maintainers = with lib.maintainers; [ AndersonTorres spacefrogg ];
=======
  meta = with lib; {
    homepage = "https://invisible-island.net/dialog/dialog.html";
    description = "Display dialog boxes from shell";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ AndersonTorres spacefrogg ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    inherit (ncurses.meta) platforms;
  };
})
