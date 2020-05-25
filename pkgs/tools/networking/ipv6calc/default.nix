{ stdenv, fetchurl, getopt, ip2location-c, openssl, perl
, libmaxminddb ? null, geolite-legacy ? null }:

stdenv.mkDerivation rec {
  pname = "ipv6calc";
  version = "2.2.0";

  src = fetchurl {
    urls = [
      "https://www.deepspace6.net/ftp/pub/ds6/sources/ipv6calc/${pname}-${version}.tar.gz"
      "ftp://ftp.deepspace6.net/pub/ds6/sources/ipv6calc/${pname}-${version}.tar.gz"
      "ftp://ftp.bieringer.de/pub/linux/IPv6/ipv6calc/${pname}-${version}.tar.gz"
    ];
    sha256 = "18acy0sy3n6jcjjwpxskysinw06czyayx1q4rqc7zc3ic4pkad8r";
  };

  buildInputs = [ libmaxminddb geolite-legacy getopt ip2location-c openssl perl ];

  postPatch = ''
    patchShebangs *.sh */*.sh
    for i in {,databases/}lib/Makefile.in; do
      substituteInPlace $i --replace "/sbin/ldconfig" "ldconfig"
    done
  '';

  configureFlags = [
    "--prefix=${placeholder "out"}"
    "--libdir=${placeholder "out"}/lib"
    "--disable-bundled-getopt"
    "--disable-bundled-md5"
    "--disable-dynamic-load"
    "--enable-shared"
  ] ++ stdenv.lib.optional (libmaxminddb != null) "--enable-mmdb"
    ++ stdenv.lib.optional (geolite-legacy != null) "--with-geoip-db=${geolite-legacy}/share/GeoIP"
    ++ stdenv.lib.optional (ip2location-c != null) "--enable-ip2location";

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
    homepage = "http://www.deepspace6.net/projects/ipv6calc.html";
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
