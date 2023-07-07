{ lib
, stdenv
, fetchurl
, fetchpatch
, m17n_db
, autoreconfHook
, pkg-config
}:
stdenv.mkDerivation rec {
  pname = "m17n-lib";
  version = "1.8.2";

  src = fetchurl {
    url = "https://download.savannah.gnu.org/releases/m17n/m17n-lib-${version}.tar.gz";
    hash = "sha256-5bA0SvnxFdlJV6P5ud68T45nG2n4wf1eC2iKeU16J/I=";
  };

  strictDeps = true;

  # reconf needed to sucesfully cross-compile
  nativeBuildInputs = [
    autoreconfHook pkg-config
    # requires m17n-db tool at build time
    m17n_db
  ];

  enableParallelBuilding = true;

  meta = {
    homepage = "https://www.nongnu.org/m17n/";
    description = "Multilingual text processing library (runtime)";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ astsmtl ];
  };
}
