{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig,
  python, boost, fuse, libtorrentRasterbar, curl }:

stdenv.mkDerivation rec {
  name = "btfs-${version}";
  version = "2.13";

  src = fetchFromGitHub {
    owner  = "johang";
    repo   = "btfs";
    rev    = "v${version}";
    sha256 = "1nd021xbxrikd8p0w9816xjwlrs9m1nc6954q23qxfw2jbmszlk2";
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
