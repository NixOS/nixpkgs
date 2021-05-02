{ stdenv, fetchurl, libpcap, tcpdump }:

stdenv.mkDerivation rec {
  pname = "tcpreplay";
  version = "4.3.4";

  src = fetchurl {
    url = "https://github.com/appneta/tcpreplay/releases/download/v${version}/tcpreplay-${version}.tar.gz";
    sha256 = "sha256-7gZTEIBsIuL9NvAU4euzMbmKfsTblY6Rw9nL2gZA2Sw=";
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
    homepage = "https://tcpreplay.appneta.com/";
    license = with licenses; [ bsdOriginalUC gpl3Only ];
    maintainers = with maintainers; [ eleanor ];
    platforms = platforms.unix;
  };
}
