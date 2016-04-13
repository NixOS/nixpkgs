{ stdenv, fetchFromGitHub, pkgconfig, autoconf, automake,
  python, boost, fuse, libtorrentRasterbar, curl }:

stdenv.mkDerivation rec {
  name = "btfs-${version}";
  version = "2.8";

  src = fetchFromGitHub {
    owner = "johang";
    repo = "btfs";
    rev = "0567010e553b290eaa50b1afaa717dd7656c82de";
    sha256 = "1x3x1v7fhcfcpffprf63sb720nxci2ap2cq92jy1xd68kmshdmwd";
  };
  
  buildInputs = [
    pkgconfig autoconf automake boost
    fuse libtorrentRasterbar curl
  ];

  preConfigure = ''
    autoreconf -i
    substituteInPlace scripts/btplay \
      --replace "/usr/bin/env python" "${python}/bin/python"
  '';

  meta = with stdenv.lib; {
    description = "A bittorrent filesystem based on FUSE";
    homepage    = "https://github.com/johang/btfs";
    license     = licenses.gpl3;
    maintainers = with maintainers; [ rnhmjoj ];
    platforms   = platforms.linux;
  };
}
