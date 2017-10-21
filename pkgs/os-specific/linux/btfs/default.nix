{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig,
  python, boost, fuse, libtorrentRasterbar, curl }:

stdenv.mkDerivation rec {
  name = "btfs-${version}";
  version = "2.17";

  src = fetchFromGitHub {
    owner  = "johang";
    repo   = "btfs";
    rev    = "v${version}";
    sha256 = "0v0mypwnx832f7vg52wmiw0lyz7rrkhqsgi7zc261ak1gfaw4nwd";
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
    homepage    = "https://github.com/johang/btfs";
    license     = licenses.gpl3;
    maintainers = with maintainers; [ rnhmjoj ];
    platforms   = platforms.linux;
  };
}
