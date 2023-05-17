{ lib
, stdenv
, fetchzip
, autoreconfHook
, dos2unix
, doxygen
, freeimage
, libpgf
}:

stdenv.mkDerivation rec {
  pname = "pgf";
  version = "7.21.7";

  src = fetchzip {
    url = "mirror://sourceforge/libpgf/libpgf/${version}/pgf-console.zip";
    hash = "sha256-W9eXYhbynLtvZQsn724Uw0SZ5TuyK2MwREwYKGFhJj0=";
  };

  postPatch = ''
    find . -type f | xargs dos2unix
    mv README.txt README
  '';

  nativeBuildInputs = [
    autoreconfHook
    dos2unix
    doxygen
  ];

  buildInputs = [
    freeimage
    libpgf
  ];

  meta = {
    homepage = "https://www.libpgf.org/";
    description = "Progressive Graphics Format command line program";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.linux;
  };
}
