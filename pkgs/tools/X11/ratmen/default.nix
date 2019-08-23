{stdenv, fetchurl, perl, xorgproto, libX11}:
let
  s = # Generated upstream information
  rec {
    baseName="ratmen";
    version="2.2.3";
    name="${baseName}-${version}";
    hash="0gnfqhnch9x8jhr87gvdjcp1wsqhchfjilpnqcwx5j0nlqyz6wi6";
    url="http://www.update.uu.se/~zrajm/programs/ratmen/ratmen-2.2.3.tar.gz";
    sha256="0gnfqhnch9x8jhr87gvdjcp1wsqhchfjilpnqcwx5j0nlqyz6wi6";
  };
  buildInputs = [
    perl xorgproto libX11
  ];
in
stdenv.mkDerivation {
  inherit (s) name version;
  inherit buildInputs;
  src = fetchurl {
    inherit (s) url sha256;
  };
  makeFlags = [
    "PREFIX=$(out)"
  ];
  meta = {
    inherit (s) version;
    description = ''A minimalistic X11 menu creator'';
    license = stdenv.lib.licenses.free ; # 9menu derivative with 9menu license
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.linux;
    homepage = http://www.update.uu.se/~zrajm/programs/;
    downloadPage = "http://www.update.uu.se/~zrajm/programs/ratmen/";
    updateWalker = true;
  };
}
