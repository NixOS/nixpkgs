{
  lib,
  stdenv,
  fetchFromGitHub,
}:
stdenv.mkDerivation rec {
  pname = "c-lolcat";
  version = "1.4";
  src = fetchFromGitHub {
    owner = "jaseg";
    repo = "lolcat";
    rev = "v${version}";
    sha256 = "+Lx6ph77Yzl4BJLgV4SE8jLe757YMCotEOiLAwgK3XM=";
  };
  installPhase = ''
    mkdir -p $out/bin
    make DESTDIR=$out/bin install
  '';

  meta = with lib; {
    description = "High-performance implementation of https://github.com/busyloop/lolcat";
    homepage = "https://github.com/jaseg/lolcat";
    license = licenses.wtfpl;
    maintainers = with lib.maintainers; [joweiss];
    platforms = platforms.linux;
  };
}
