{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig
, python3, boost, fuse, libtorrentRasterbar, curl }:

stdenv.mkDerivation rec {
  pname = "btfs";
  version = "2.22";

  src = fetchFromGitHub {
    owner  = "johang";
    repo   = pname;
    rev    = "v${version}";
    sha256 = "1z88bk1z4sns3jdn56x83mvh06snxg0lr5h4v0c24lzlf5wbdifz";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig ];
  buildInputs = [
    boost fuse libtorrentRasterbar curl python3
  ];

  meta = with stdenv.lib; {
    description = "A bittorrent filesystem based on FUSE";
    homepage    = "https://github.com/johang/btfs";
    license     = licenses.gpl3;
    maintainers = with maintainers; [ rnhmjoj ];
    platforms   = platforms.linux;
  };
}
