{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig
, python3, boost, fuse, libtorrentRasterbar, curl }:

stdenv.mkDerivation rec {
  pname = "btfs";
  version = "2.20";

  src = fetchFromGitHub {
    owner  = "johang";
    repo   = pname;
    rev    = "v${version}";
    sha256 = "1xil18nmivakdv6rz4sd3203gzfisdvj79spni59kv7dby64rxdz";
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
