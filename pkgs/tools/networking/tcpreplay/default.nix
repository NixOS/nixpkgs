{ stdenv, fetchurl, libpcap, tcpdump }:

stdenv.mkDerivation rec {
  name = "tcpreplay-${version}";
  version = "4.2.5";

  src = fetchurl {
    url = "https://github.com/appneta/tcpreplay/releases/download/v${version}/tcpreplay-${version}.tar.gz";
    sha256 = "1mw9r97blczm70rjf7p83sd1fxpzdzfvsbnjsc0m3nz16jz2c44l";
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

  meta = {
    description = "A suite of utilities for editing and replaying network traffic";
    homepage = http://tcpreplay.appneta.com/;
    license = with stdenv.lib.licenses; [ bsd gpl3 ];
    maintainers = with stdenv.lib.maintainers; [ eleanor ];
    platforms = stdenv.lib.platforms.linux;
  };
}
