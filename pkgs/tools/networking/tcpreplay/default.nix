{ stdenv, fetchurl, libpcap, tcpdump }:

stdenv.mkDerivation rec {
  name = "tcpreplay-${version}";
  version = "4.2.6";

  src = fetchurl {
    url = "https://github.com/appneta/tcpreplay/releases/download/v${version}/tcpreplay-${version}.tar.gz";
    sha256 = "07aklkc1s13hwrd098bqj8izfh8kdgs7wl9swcmkxffs6b2mcdq4";
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
    homepage = http://tcpreplay.appneta.com/;
    license = with licenses; [ bsd3 gpl3 ];
    maintainers = with maintainers; [ eleanor ];
    platforms = platforms.linux;
  };
}
