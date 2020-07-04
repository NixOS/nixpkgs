{ stdenv, fetchurl, libpcap, tcpdump }:

stdenv.mkDerivation rec {
  pname = "tcpreplay";
  version = "4.3.3";

  src = fetchurl {
    url = "https://github.com/appneta/tcpreplay/releases/download/v${version}/tcpreplay-${version}.tar.gz";
    sha256 = "1plgjm3dr9rr5q71s7paqk2wgrvkihbk2yrf9g3zaks3m750497d";
  };

  buildInputs = [ libpcap ];

  configureFlags = [
    "--disable-local-libopts"
    "--disable-libopts-install"
    "--enable-dynamic-link"
    "--enable-shared"
    "--enable-tcpreplay-edit"
    "--with-libpcap=${libpcap}"
    "--with-tcpdump=${tcpdump}/bin"
  ];

  meta = with stdenv.lib; {
    description = "A suite of utilities for editing and replaying network traffic";
    homepage = "http://tcpreplay.appneta.com/";
    license = with licenses; [ bsd3 gpl3 ];
    maintainers = with maintainers; [ eleanor ];
    platforms = platforms.linux;
  };
}
