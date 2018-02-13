{ stdenv, fetchurl, pkgconfig, readline, libxml2 }:

stdenv.mkDerivation rec {
  name = "augeas-${version}";
  version = "1.10.1";

  src = fetchurl {
    url = "http://download.augeas.net/${name}.tar.gz";
    sha256 = "0k9nssn7lk58cl5zv3c8kv2zx9cm2yks3sj7q4fd6qdjz9m2bnsj";
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
