{
  lib,
  stdenv,
  fetchurl,
  xz,
}:

stdenv.mkDerivation rec {
  pname = "autoconf-archive";
  version = "2023.02.20";

  src = fetchurl {
    url = "mirror://gnu/autoconf-archive/autoconf-archive-${version}.tar.xz";
    hash = "sha256-cdQEhHmuKPH1eUYZw9ct+cAd9JscYo74X943WW3DGjM=";
  };

  strictDeps = true;
  enableParallelBuilding = true;

  buildInputs = [ xz ];

  meta = with lib; {
    description = "Archive of autoconf m4 macros";
    homepage = "https://www.gnu.org/software/autoconf-archive/";
    license = licenses.gpl3;
    platforms = platforms.unix;
  };
}
