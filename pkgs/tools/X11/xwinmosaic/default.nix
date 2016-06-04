{stdenv, fetchgit, gtk2, cmake, pkgconfig}:
let
  buildInputs = [
    gtk2 cmake pkgconfig
  ];
in
stdenv.mkDerivation rec {
  version = "0.4.2";
  name = "xwinmosaic-${version}";
  inherit buildInputs;
  src = fetchgit {
    url = "https://github.com/soulthreads/xwinmosaic/";
    rev = "refs/tags/v0.4.2";
    sha256 = "16qhrpgn84fz0q3nfvaz5sisc82zk6y7c0sbvbr69zfx5fwbs1rr";
  };
  meta = {
    inherit version;
    description = ''X window switcher drawing a colourful grid'';
    license = stdenv.lib.licenses.bsd2 ;
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.linux;
  };
}
