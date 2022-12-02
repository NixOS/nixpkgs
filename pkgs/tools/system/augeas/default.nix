{ lib, stdenv, fetchurl, pkg-config, readline, libxml2 }:

stdenv.mkDerivation rec {
  pname = "augeas";
  version = "1.12.0";

  src = fetchurl {
    url = "http://download.augeas.net/${pname}-${version}.tar.gz";
    sha256 = "11ybhb13wkkilsn7b416a1dn61m1xrq0lbdpkhp5w61jrk4l469j";
  };
  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ readline libxml2 ];

  meta = with lib; {
    description = "Configuration editing tool";
    license = licenses.lgpl21Only;
    homepage = "https://augeas.net/";
    maintainers = with maintainers; [ offline ];
    platforms = platforms.unix;
  };
}
