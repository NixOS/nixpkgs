{ lib, stdenv, fetchurl, pkg-config, meson, ninja, glib, libintl }:

stdenv.mkDerivation rec {
  pname = "desktop-file-utils";
  version = "0.26";

  src = fetchurl {
    url = "https://www.freedesktop.org/software/${pname}/releases/${pname}-${version}.tar.xz";
    sha256 = "02bkfi6fyk4c0gh2avd897882ww5zl7qg7bzzf28qb57kvkvsvdj";
  };

  nativeBuildInputs = [ pkg-config meson ninja ];
  buildInputs = [ glib libintl ];

  postPatch = ''
    substituteInPlace src/install.c \
      --replace \"update-desktop-database\" \"$out/bin/update-desktop-database\"
  '';

  setupHook = ./setup-hook.sh;

  meta = with lib; {
    homepage = "http://www.freedesktop.org/wiki/Software/desktop-file-utils";
    description = "Command line utilities for working with .desktop files";
    platforms = platforms.linux ++ platforms.darwin;
    license = licenses.gpl2;
  };
}
