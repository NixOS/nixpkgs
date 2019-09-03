{ stdenv, fetchurl, getopt, ip2location-c, openssl, perl
, geoip ? null, geolite-legacy ? null }:

stdenv.mkDerivation rec {
  pname = "ipv6calc";
  version = "1.1.0";

  src = fetchurl {
    url = "ftp://ftp.deepspace6.net/pub/ds6/sources/ipv6calc/${pname}-${version}.tar.gz";
    sha256 = "1q74ikg780v5hllbq08wdfvxr2lf0fc7i41hclqrh1ajc6dqybbq";
  };

  buildInputs = [ geoip geolite-legacy getopt ip2location-c openssl ];
  nativeBuildInputs = [ perl ];

  patchPhase = ''
    for i in {,databases/}lib/Makefile.in; do
      substituteInPlace $i --replace /sbin/ldconfig true
    done
    for i in {{,databases/}lib,man}/Makefile.in; do
      substituteInPlace $i --replace DESTDIR out
    done
  '';

  configureFlags = [
    "--disable-bundled-getopt"
    "--disable-bundled-md5"
    "--disable-dynamic-load"
    "--enable-shared"
  ] ++ stdenv.lib.optional (geoip != null ) [
    "--enable-geoip"
  ] ++ stdenv.lib.optional (geolite-legacy != null) [
    "--with-geoip-db=${geolite-legacy}/share/GeoIP"
  ] ++ stdenv.lib.optional (ip2location-c != null ) [
    "--enable-ip2location"
  ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Calculate/manipulate (not only) IPv6 addresses";
    longDescription = ''
      ipv6calc is a small utility to manipulate (not only) IPv6 addresses and
      is able to do other tricky things. Intentions were convering a given
      IPv6 address into compressed format, convering a given IPv6 address into
      the same format like shown in /proc/net/if_inet6 and (because it was not
      difficult) migrating the Perl program ip6_int into.
      Now only one utiltity is needed to do a lot.
    '';
    homepage = http://www.deepspace6.net/projects/ipv6calc.html;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
