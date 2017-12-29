{ stdenv, fetchurl, pkgconfig, readline, libxml2 }:

stdenv.mkDerivation rec {
  name = "augeas-${version}";
  version = "1.8.1";

  src = fetchurl {
    url = "http://download.augeas.net/${name}.tar.gz";
    sha256 = "1yf93fqwav1zsl8dpyfkf0g11w05mmfckqy6qsjy5zkklnspbkv5";
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
