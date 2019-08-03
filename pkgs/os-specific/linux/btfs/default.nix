{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig
, python3, boost, fuse, libtorrentRasterbar, curl }:

stdenv.mkDerivation rec {
  pname = "btfs";
  version = "2.19";

  src = fetchFromGitHub {
    owner  = "johang";
    repo   = pname;
    rev    = "v${version}";
    sha256 = "1b58zqha2hpnk4ysp9870wd9pkyy6l106ghp0z0x655q70npj0wn";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig ];
  buildInputs = [
    boost fuse libtorrentRasterbar curl
  ];

  preInstall = ''
    substituteInPlace scripts/btplay \
      --replace "/usr/bin/env python" "${python3.interpreter}"
  '';

  meta = with stdenv.lib; {
    description = "A bittorrent filesystem based on FUSE";
    homepage    = https://github.com/johang/btfs;
    license     = licenses.gpl3;
    maintainers = with maintainers; [ rnhmjoj ];
    platforms   = platforms.linux;
  };
}
