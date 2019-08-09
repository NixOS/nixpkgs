{ stdenv, fetchurl, pkgconfig, readline, libxml2 }:

stdenv.mkDerivation rec {
  name = "augeas-${version}";
  version = "1.12.0";

  src = fetchurl {
    url = "http://download.augeas.net/${name}.tar.gz";
    sha256 = "11ybhb13wkkilsn7b416a1dn61m1xrq0lbdpkhp5w61jrk4l469j";
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
