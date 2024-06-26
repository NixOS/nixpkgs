{
  stdenv,
  lib,
  fetchurl,
  pkg-config,
  meson,
  ninja,
  glib,
  libintl,
}:

stdenv.mkDerivation rec {
  pname = "desktop-file-utils";
  version = "0.27";

  src = fetchurl {
    url = "https://www.freedesktop.org/software/${pname}/releases/${pname}-${version}.tar.xz";
    hash = "sha256-oIF985zjhbZiGIBAfFbx8pgWjAQMIDLO34jVt2r/6DY=";
  };

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
  ];

  buildInputs = [
    glib
    libintl
  ];

  postPatch = ''
    substituteInPlace src/install.c \
      --replace \"update-desktop-database\" \"$out/bin/update-desktop-database\"
  '';

  setupHook = ./setup-hook.sh;

  meta = with lib; {
    homepage = "https://www.freedesktop.org/wiki/Software/desktop-file-utils";
    description = "Command line utilities for working with .desktop files";
    platforms = platforms.linux ++ platforms.darwin;
    license = licenses.gpl2Plus;
  };
}
