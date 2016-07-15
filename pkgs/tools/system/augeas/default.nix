{ stdenv, fetchurl, pkgconfig, readline, libxml2 }:

stdenv.mkDerivation rec {
  name = "augeas-${version}";
  version = "1.5.0";

  src = fetchurl {
    url = "http://download.augeas.net/${name}.tar.gz";
    sha256 = "0gzpafrflkr0incq58vjkabfncrpc97d7mdgglkr57iyzvkbcfr2";
  };

  buildInputs = [ pkgconfig readline libxml2 ];

  meta = with stdenv.lib; {
    description = "Configuration editing tool";
    license = licenses.lgpl2;
    homepage = http://augeas.net/;
    maintainers = with maintainers; [offline];
    platforms = platforms.unix;
  };
}
