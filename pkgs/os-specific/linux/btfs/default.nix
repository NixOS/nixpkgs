{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig,
  python, boost, fuse, libtorrentRasterbar, curl }:

stdenv.mkDerivation rec {
  name = "btfs-${version}";
  version = "2.12";

  src = fetchFromGitHub {
    owner = "johang";
    repo = "btfs";
    rev = "daeb2fd43795f0bb9a4861279b6064b35186ff25";
    sha256 = "1apvf1gp5973s4wlzwndxp711yd9pj9zf2ypdssfxv2a3rihly2b";
  };

  buildInputs = [
    boost autoreconfHook pkgconfig
    fuse libtorrentRasterbar curl
  ];

  preInstall = ''
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
