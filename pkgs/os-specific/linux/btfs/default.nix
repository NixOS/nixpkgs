{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig,
  python, boost, fuse, libtorrentRasterbar, curl }:

stdenv.mkDerivation rec {
  name = "btfs-${version}";
  version = "2.11";

  src = fetchFromGitHub {
    owner = "johang";
    repo = "btfs";
    rev = "fe585ca285690579db50b1624cec81ae76279ba2";
    sha256 = "1vqya2k8cx5x7jfapl9vmmb002brwbsz4j5xs4417kzv3j2bsms9";
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
