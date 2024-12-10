{
  lib,
  stdenv,
  fetchurl,
  perl,
  xorgproto,
  libX11,
}:

stdenv.mkDerivation rec {
  pname = "ratmen";
  version = "2.2.3";
  src = fetchurl {
    url = "http://www.update.uu.se/~zrajm/programs/ratmen/ratmen-${version}.tar.gz";
    sha256 = "0gnfqhnch9x8jhr87gvdjcp1wsqhchfjilpnqcwx5j0nlqyz6wi6";
  };
  buildInputs = [
    perl
    xorgproto
    libX11
  ];
  makeFlags = [
    "PREFIX=$(out)"
  ];
  meta = with lib; {
    description = "A minimalistic X11 menu creator";
    license = licenses.free; # 9menu derivative with 9menu license
    maintainers = with maintainers; [ raskin ];
    platforms = platforms.linux;
    homepage = "http://www.update.uu.se/~zrajm/programs/";
    downloadPage = "http://www.update.uu.se/~zrajm/programs/ratmen/";
    mainProgram = "ratmen";
  };
}
