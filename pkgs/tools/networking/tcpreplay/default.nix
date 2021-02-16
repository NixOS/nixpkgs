{ lib, stdenv, fetchurl, libpcap, tcpdump, Carbon, CoreServices }:

stdenv.mkDerivation rec {
  pname = "tcpreplay";
  version = "4.3.3";

  src = fetchurl {
    url = "https://github.com/appneta/tcpreplay/releases/download/v${version}/tcpreplay-${version}.tar.gz";
    sha256 = "1plgjm3dr9rr5q71s7paqk2wgrvkihbk2yrf9g3zaks3m750497d";
  };

  buildInputs = [ libpcap ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      Carbon CoreServices
    ];


  configureFlags = [
    "--disable-local-libopts"
    "--disable-libopts-install"
    "--enable-dynamic-link"
    "--enable-shared"
    "--enable-tcpreplay-edit"
    "--with-libpcap=${libpcap}"
    "--with-tcpdump=${tcpdump}/bin"
  ];

  meta = with lib; {
    description = "A suite of utilities for editing and replaying network traffic";
    homepage = "http://tcpreplay.appneta.com/";
    license = with licenses; [ bsd3 gpl3 ];
    maintainers = with maintainers; [ eleanor ];
    platforms = platforms.unix;
    knownVulnerabilities = [
      "CVE-2020-24265" # https://github.com/appneta/tcpreplay/issues/616
      "CVE-2020-24266" # https://github.com/appneta/tcpreplay/issues/617
    ];
  };
}
