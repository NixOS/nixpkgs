{ stdenv, fetchurl, pkgconfig, readline, libxml2 }:

stdenv.mkDerivation rec {
  name = "augeas-${version}";
  version = "1.2.0";

  src = fetchurl {
    url = "http://download.augeas.net/${name}.tar.gz";
    sha256 = "1q41yilxc0nvjz5h9phm38k2b73k2v0b9jg11y92228bps7b5bpl";
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
