{
  lib,
  stdenv,
  fetchFromGitHub,
  libxcb,
  xcbutil,
  xcbutilwm,
}:

stdenv.mkDerivation rec {
  pname = "xdo";
  version = "0.5.7";

  src = fetchFromGitHub {
    owner = "baskerville";
    repo = "xdo";
    rev = version;
    sha256 = "1h3jrygcjjbavdbkpx2hscsf0yf97gk487lzjdlvymd7dxdv9hy9";
  };

  makeFlags = [ "PREFIX=$(out)" ];

  buildInputs = [
    libxcb
    xcbutilwm
    xcbutil
  ];

  meta = with lib; {
    description = "Small X utility to perform elementary actions on windows";
    homepage = "https://github.com/baskerville/xdo";
    maintainers = with maintainers; [ meisternu ];
    license = licenses.bsd2;
    platforms = platforms.linux;
    mainProgram = "xdo";
  };
}
