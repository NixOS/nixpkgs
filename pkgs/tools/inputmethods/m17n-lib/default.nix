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
  nativeBuildInputs = [ autoreconfHook pkg-config ];

  buildInputs = [ m17n_db ];

  meta = {
    homepage = "https://www.nongnu.org/m17n/";
    description = "Multilingual text processing library (runtime)";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ astsmtl ];
  };
}
