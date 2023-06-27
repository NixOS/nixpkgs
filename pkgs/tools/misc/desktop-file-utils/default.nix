{ stdenv
, lib
, fetchurl
, fetchpatch
, pkg-config
, meson
, ninja
, glib
, libintl
}:

stdenv.mkDerivation rec {
  pname = "desktop-file-utils";
  version = "0.26";

  src = fetchurl {
    url = "https://www.freedesktop.org/software/${pname}/releases/${pname}-${version}.tar.xz";
    sha256 = "02bkfi6fyk4c0gh2avd897882ww5zl7qg7bzzf28qb57kvkvsvdj";
  };

  patches = [
    # Support Desktop Entry Specification v1.5.
    # https://gitlab.freedesktop.org/xdg/desktop-file-utils/-/merge_requests/11
    (fetchpatch {
      url = "https://gitlab.freedesktop.org/xdg/desktop-file-utils/-/commit/425177a28b6215e0745f95100160a08e810fd47c.patch";
      sha256 = "zu9EqTnQQGi5HqKh431JqigtJi+b16RuXSWQYbuuyxA=";
    })
    (fetchpatch {
      url = "https://gitlab.freedesktop.org/xdg/desktop-file-utils/-/commit/56d220dd679c7c3a8f995a41a27a7d6f3df49dea.patch";
      sha256 = "p4kamGIm2QBHfIbvDnx+qu5Gi7OU3Z0nQKr39SsEKqk=";
    })
  ];

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
    homepage = "http://www.freedesktop.org/wiki/Software/desktop-file-utils";
    description = "Command line utilities for working with .desktop files";
    platforms = platforms.linux ++ platforms.darwin;
    license = licenses.gpl2Plus;
  };
}
