{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "dibbler-${version}";
  version = "1.0.1";

  src = fetchurl {
    url = "http://www.klub.com.pl/dhcpv6/dibbler/${name}.tar.gz";
    sha256 = "18bnwkvax02scjdg5z8gvrkvy1lhssfnlpsaqb5kkh30w1vri1i7";
  };

  configureFlags = [
    "--enable-resolvconf"
  ];

  meta = with stdenv.lib; {
    description = "Portable DHCPv6 implementation";
    homepage = http://www.klub.com.pl/dhcpv6/;
    license = licenses.gpl2;
    platforms = platforms.all;
    maintainers = with maintainers; [ fpletz ];
  };
}
