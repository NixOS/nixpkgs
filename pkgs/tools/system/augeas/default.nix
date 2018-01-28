{ stdenv, fetchurl, pkgconfig, readline, libxml2 }:

stdenv.mkDerivation rec {
  name = "augeas-${version}";
  version = "1.10.0";

  src = fetchurl {
    url = "http://download.augeas.net/${name}.tar.gz";
    sha256 = "04q2hr3xj71rdbjdj3jiygi8dbiq1x4szlyavxj1xjiw9jcgd41a";
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
