{ stdenv, fetchurl, geoip, getopt, openssl, perl }:

stdenv.mkDerivation rec {
  version = "0.98.0";
  name = "ipv6calc-${version}";

  src = fetchurl {
    url = "ftp://ftp.deepspace6.net/pub/ds6/sources/ipv6calc/${name}.tar.gz";
    sha256 = "1wdlyklqjvslcbvyx7ch4aziwvjbpj852k59m02gakisq9bywfcd";
  };

  buildInputs = [ geoip getopt openssl perl ];

  patchPhase = ''
    for i in {,databases/}lib/Makefile.in; do
      substituteInPlace $i --replace /sbin/ldconfig true
    done
    for i in {{,databases/}lib,man}/Makefile.in; do
      substituteInPlace $i --replace DESTDIR out
    done
  '';

  configureFlags = ''
    --disable-bundled-getopt
    --disable-bundled-md5
    --disable-dynamic-load
    --enable-shared
    --enable-geoip
    --with-geoip-db=${geoip}/share/GeoIP
  '';

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
    license = with licenses; gpl2;
    platforms = with platforms; linux;
    maintainers = with maintainers; [ nckx ];
  };
}
