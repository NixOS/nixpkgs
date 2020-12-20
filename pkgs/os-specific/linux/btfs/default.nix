{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig
, python3, boost, fuse, libtorrent-rasterbar, curl }:

stdenv.mkDerivation rec {
  pname = "btfs";
  version = "2.23";

  src = fetchFromGitHub {
    owner  = "johang";
    repo   = pname;
    rev    = "v${version}";
    sha256 = "1cfjhyn9cjyyxyd0f08b2ra258pzkljwvkj0iwrjpd0nrbl6wkq5";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig ];
  buildInputs = [
    boost fuse libtorrent-rasterbar curl python3
  ];

  meta = with stdenv.lib; {
    description = "A bittorrent filesystem based on FUSE";
    homepage    = "https://github.com/johang/btfs";
    license     = licenses.gpl3;
    maintainers = with maintainers; [ rnhmjoj ];
    platforms   = platforms.linux;
  };
}
