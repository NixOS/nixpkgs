{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig,
  python, boost, fuse, libtorrentRasterbar, curl }:

stdenv.mkDerivation rec {
  name = "btfs-${version}";
  version = "2.9";

  src = fetchFromGitHub {
    owner = "johang";
    repo = "btfs";
    rev = "3ee6671eca2c0e326ac38d07cab4989ebad3495c";
    sha256 = "0f7yc7hkfwdj9hixsyswf17yrpcpwxxb0svj5lfqcir8a45kf100";
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
