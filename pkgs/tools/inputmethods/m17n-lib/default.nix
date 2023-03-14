{ lib, stdenv, fetchurl, fetchpatch, m17n_db, autoreconfHook, pkg-config }:
stdenv.mkDerivation rec {
  pname = "m17n-lib";
  version = "1.8.0";

  src = fetchurl {
    url = "https://download.savannah.gnu.org/releases/m17n/m17n-lib-${version}.tar.gz";
    sha256 = "0jp61y09xqj10mclpip48qlfhniw8gwy8b28cbzxy8hq8pkwmfkq";
  };

  patches = [
    (fetchpatch {
      # Patch pending upstream inclusion:
      #   https://savannah.nongnu.org/bugs/index.php?61377
      name = "parallel-build.patch";
      url = "https://savannah.nongnu.org/bugs/download.php?file_id=53704";
      hash = "sha256-1smKSIFVRJZSwCv0NiUsnndxKcPnJ/wqzH8+ka6nfNM=";
      excludes = [ "src/ChangeLog" ];
    })
  ];

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
