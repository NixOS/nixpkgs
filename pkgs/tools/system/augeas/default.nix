{ stdenv, fetchurl, pkgconfig, readline, libxml2 }:

stdenv.mkDerivation rec {
  name = "augeas-${version}";
  version = "1.7.0";

  src = fetchurl {
    url = "http://download.augeas.net/${name}.tar.gz";
    sha256 = "0qwpjz23z1x7dkf5k2y9f1cppryzhx4hpxprla6a4yvzs1smacdr";
  };
  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ readline libxml2 ];

  meta = with stdenv.lib; {
    description = "Configuration editing tool";
    license = licenses.lgpl2;
    homepage = http://augeas.net/;
    maintainers = with maintainers; [ offline ndowens ];
    platforms = platforms.unix;
  };
}
