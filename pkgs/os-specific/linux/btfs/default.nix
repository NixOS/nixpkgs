{ stdenv, fetchFromGitHub, pkgconfig, autoconf, automake,
  python, boost, fuse, libtorrentRasterbar, curl }:

stdenv.mkDerivation rec {
  name = "btfs-${version}";
  version = "2.7";

  src = fetchFromGitHub {
    owner = "johang";
    repo = "btfs";
    rev = "e816b4718bd5c9d88a99805d19d2ad91971b2338";
    sha256 = "1mac2dwg0pzpmg0x503a8d8gx3ridi4m1qx4jk6ssvl4g9v6p7fl";
  };
  
  buildInputs = [
    pkgconfig autoconf automake boost
    fuse libtorrentRasterbar curl
  ];

  preConfigure = ''
    autoreconf -i
    substituteInPlace scripts/btplay \
      --replace /usr/bin/python ${python}/bin/python
  '';

  meta = with stdenv.lib; {
    description = "A bittorrent filesystem based on FUSE";
    homepage    = "https://github.com/johang/btfs";
    license     = licenses.gpl3;
    maintainers = with maintainers; [ rnhmjoj ];
    platforms   = platforms.linux;
  };
}
