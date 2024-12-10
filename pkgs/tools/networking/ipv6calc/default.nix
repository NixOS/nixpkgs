{
  lib,
  stdenv,
  fetchFromGitHub,
  getopt,
  ip2location-c,
  openssl,
  perl,
  libmaxminddb ? null,
  geolite-legacy ? null,
}:

stdenv.mkDerivation rec {
  pname = "ipv6calc";
  version = "4.2.0";

  src = fetchFromGitHub {
    owner = "pbiering";
    repo = pname;
    rev = version;
    sha256 = "sha256-z4CfakCvFdCPwB52wfeooCMI51QY629nMDbCmR50fI4=";
  };

  buildInputs = [
    libmaxminddb
    geolite-legacy
    getopt
    ip2location-c
    openssl
    perl
  ];

  postPatch = ''
    patchShebangs *.sh */*.sh
    for i in {,databases/}lib/Makefile.in; do
      substituteInPlace $i --replace "/sbin/ldconfig" "ldconfig"
    done
  '';

  configureFlags =
    [
      "--prefix=${placeholder "out"}"
      "--libdir=${placeholder "out"}/lib"
      "--datadir=${placeholder "out"}/share"
      "--disable-bundled-getopt"
      "--disable-bundled-md5"
      "--disable-dynamic-load"
      "--enable-shared"
    ]
    ++ lib.optionals (libmaxminddb != null) [
      "--enable-mmdb"
    ]
    ++ lib.optionals (geolite-legacy != null) [
      "--with-geoip-db=${geolite-legacy}/share/GeoIP"
    ]
    ++ lib.optionals (ip2location-c != null) [
      "--enable-ip2location"
    ];

  enableParallelBuilding = true;

  meta = with lib; {
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
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ ];
    platforms = platforms.linux;
  };
}
