{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "dibbler";
  version = "1.0.1";

  src = fetchurl {
    url = "http://www.klub.com.pl/dhcpv6/dibbler/${pname}-${version}.tar.gz";
    sha256 = "18bnwkvax02scjdg5z8gvrkvy1lhssfnlpsaqb5kkh30w1vri1i7";
  };

  configureFlags = [
    "--enable-resolvconf"
  ];

  NIX_CFLAGS_COMPILE = lib.optionalString stdenv.isDarwin "-D__APPLE_USE_RFC_2292=1";

  meta = with lib; {
    description = "Portable DHCPv6 implementation";
    homepage = "https://klub.com.pl/dhcpv6/";
    license = licenses.gpl2Only;
    platforms = platforms.all;
    maintainers = with maintainers; [ fpletz ];
  };
}
