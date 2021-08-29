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
  version = "1.5.3";

  src = fetchFromGitHub {
    owner = "nhorman";
    repo = pname;
    rev = "v${version}";
    sha256 = "0axx0zzrs7apqnl0r70jyvmgk7cs5wk185id479mapgngibwkyxy";
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
