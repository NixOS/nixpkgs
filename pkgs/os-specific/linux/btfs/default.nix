{ lib, stdenv, fetchFromGitHub, autoreconfHook, pkg-config
, python3, boost, fuse, libtorrent-rasterbar, curl }:

stdenv.mkDerivation rec {
  pname = "btfs";
  version = "2.24";

  src = fetchFromGitHub {
    owner  = "johang";
    repo   = pname;
    rev    = "v${version}";
    sha256 = "sha256-fkS0U/MqFRQNi+n7NE4e1cnNICvfST2IQ9FMoJUyj6w=";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config ];
  buildInputs = [
    boost fuse libtorrent-rasterbar curl python3
  ];

  meta = with lib; {
    description = "Bittorrent filesystem based on FUSE";
    homepage    = "https://github.com/johang/btfs";
    license     = licenses.gpl3;
    maintainers = with maintainers; [ rnhmjoj ];
    platforms   = platforms.unix;
  };
}
