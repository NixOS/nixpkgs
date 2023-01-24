{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook
, pkg-config
, libbfd
, libnl
, libpcap
, ncurses
, readline
, zlib
}:

stdenv.mkDerivation rec {
  pname = "dropwatch";
  version = "1.5.4";

  src = fetchFromGitHub {
    owner = "nhorman";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-TbhgcX5WzuigP5/Mj5JuK7O/UKcu70D7dcOcvo4fxeQ=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];
  buildInputs = [
    libbfd
    libnl
    libpcap
    ncurses
    readline
    zlib
  ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Linux kernel dropped packet monitor";
    homepage = "https://github.com/nhorman/dropwatch";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ c0bw3b ];
  };
}
