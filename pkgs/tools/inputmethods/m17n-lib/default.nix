{ lib, stdenv, fetchurl, m17n_db, autoreconfHook, pkg-config }:
stdenv.mkDerivation rec {
  pname = "m17n-lib";
  version = "1.8.0";

  src = fetchurl {
    url = "https://download.savannah.gnu.org/releases/m17n/m17n-lib-${version}.tar.gz";
    sha256 = "0jp61y09xqj10mclpip48qlfhniw8gwy8b28cbzxy8hq8pkwmfkq";
  };

  strictDeps = true;

  # reconf needed to sucesfully cross-compile
  nativeBuildInputs = [
    autoreconfHook pkg-config
    # requires m17n-db tool at build time
    m17n_db
  ];

  # Fails parallel build due to missing intra-package depends:
  #   https://savannah.nongnu.org/bugs/index.php?61377
  #     make[2]: *** No rule to make target '../src/libm17n-core.la', needed by 'libm17n.la'.  Stop.
  enableParallelBuilding = false;

  meta = {
    homepage = "https://www.nongnu.org/m17n/";
    description = "Multilingual text processing library (runtime)";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ astsmtl ];
  };
}
