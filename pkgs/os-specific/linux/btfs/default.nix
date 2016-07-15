{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig,
  python, boost, fuse, libtorrentRasterbar, curl }:

stdenv.mkDerivation rec {
  name = "btfs-${version}";
  version = "2.10";

  src = fetchFromGitHub {
    owner = "johang";
    repo = "btfs";
    rev = "2eac5e70a1ed22fa0761b6357c54fd90eea02de6";
    sha256 = "146vgwn79dnbkkn35safga55lkwhvarkmilparmr26hjb56cs1dk";
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
