{stdenv, fetchurl, ncurses, libpcap }:

stdenv.mkDerivation rec {
  version = "3.6.0";

  pname = "sipp";

  src = fetchurl {
    url = "https://github.com/SIPp/${pname}/releases/download/v${version}/${pname}-${version}.tar.gz";
    sha256 = "1fx1iy2n0m2kr91n1ii30frbscq375k3lqihdgvrqxn0zq8pnzp4";
  };

  postPatch = ''
    sed -i "s@pcap/\(.*\).pcap@$out/share/pcap/\1.pcap@g" src/scenario.cpp
  '';

  configureFlags = [
    "--with-pcap"
  ];

  postInstall = ''
    mkdir -pv $out/share/pcap
    cp pcap/* $out/share/pcap
  '';

  buildInputs = [ncurses libpcap];

  meta = with stdenv.lib; {
    homepage = http://sipp.sf.net;
    description = "The SIPp testing tool";
    license = licenses.gpl3;
    platforms = platforms.unix;
  };
}

