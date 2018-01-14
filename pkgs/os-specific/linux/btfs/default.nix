{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig,
  python, boost, fuse, libtorrentRasterbar, curl }:

stdenv.mkDerivation rec {
  name = "btfs-${version}";
  version = "2.18";

  src = fetchFromGitHub {
    owner  = "johang";
    repo   = "btfs";
    rev    = "v${version}";
    sha256 = "1cn21bxx43iqvac6scmwhkw0bql092sl48r6qfidbmhbw30xl5yf";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [
    boost autoreconfHook
    fuse libtorrentRasterbar curl
  ];

  preInstall = ''
    substituteInPlace scripts/btplay \
      --replace "/usr/bin/env python" "${python}/bin/python"
  '';

  meta = with stdenv.lib; {
    description = "A bittorrent filesystem based on FUSE";
    homepage    = https://github.com/johang/btfs;
    license     = licenses.gpl3;
    maintainers = with maintainers; [ rnhmjoj ];
    platforms   = platforms.linux;
  };
}
