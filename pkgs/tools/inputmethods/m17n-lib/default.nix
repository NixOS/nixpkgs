{
  lib,
  stdenv,
  fetchurl,
  m17n_db,
  autoreconfHook,
  pkg-config,
  autoPatchPcHook,
}:
stdenv.mkDerivation rec {
  pname = "m17n-lib";
  version = "1.8.5";

  src = fetchurl {
    url = "https://download.savannah.gnu.org/releases/m17n/m17n-lib-${version}.tar.gz";
    hash = "sha256-e2xCX3ktBtFOT1sXIE02J+LI67Qj69rpLAxkZxDT1sc=";
  };

  strictDeps = true;

  # reconf needed to successfully cross-compile
  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    autoPatchPcHook
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
