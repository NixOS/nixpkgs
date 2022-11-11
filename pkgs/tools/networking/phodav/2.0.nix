{ lib
, stdenv
, fetchurl
, fetchpatch
, pkg-config
, libsoup
, meson
, ninja
}:

stdenv.mkDerivation rec {
  pname = "phodav";
  version = "2.5";

  outputs = [ "out" "dev" "lib" ];

  src = fetchurl {
    url = "http://ftp.gnome.org/pub/GNOME/sources/phodav/${version}/${pname}-${version}.tar.xz";
    sha256 = "045rdzf8isqmzix12lkz6z073b5qvcqq6ad028advm5gf36skw3i";
  };

  patches = [
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/phodav/-/commit/ae9ac98c1b3db26070111661aba02594c62d2cef.patch";
      sha256 = "sha256-jIHG6aRqG00Q6aIQsn4tyQdy/b6juW6QiUPXLmIc3TE=";
    })
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/phodav/-/commit/560ab5ca4f836d82bddbbe66ea0f7c6b4cab6b3b.patch";
      sha256 = "sha256-2gP579qhEkp7fQ8DBGYbZcjb2Tr+WpJs30Z7lsQaz2g=";
    })
  ];

  mesonFlags = [
    "-Davahi=disabled"
    "-Dsystemd=disabled"
    "-Dgtk_doc=disabled"
    "-Dudev=disabled"
  ];

  NIX_LDFLAGS = lib.optionalString stdenv.isDarwin "-lintl";

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
  ];

  buildInputs = [
    libsoup
  ];

  meta = with lib; {
    description = "WebDav server implementation and library using libsoup 2";
    homepage = "https://wiki.gnome.org/phodav";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ wegank ];
    platforms = platforms.unix;
  };
}
