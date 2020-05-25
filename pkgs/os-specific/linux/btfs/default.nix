{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig
, python3, boost, fuse, libtorrentRasterbar, curl }:

stdenv.mkDerivation rec {
  pname = "btfs";
  version = "2.21";

  src = fetchFromGitHub {
    owner  = "johang";
    repo   = pname;
    rev    = "v${version}";
    sha256 = "0zqkzfc49jl9kn3m0cg7q0156xyzrdl5w4v70p16sqxdly86mwb0";
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
