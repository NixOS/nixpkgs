{stdenv, fetchurl, libX11, libSM, SDL, mesa, expat, SDL_ttf, SDL_image, zlib}:
let
  buildInputs = [
    libX11 libSM SDL SDL_ttf SDL_image mesa expat zlib
  ];
in
stdenv.mkDerivation rec {
  version = "4.7.3";
  name = "xpilot-ng-${version}";
  inherit buildInputs;
  src = fetchurl {
    url = "mirror://sourceforge/xpilot/xpilot_ng/${name}/${name}.tar.gz";
    sha256 = "02a7pnp88kh88fzda5q8mzlckk6y9r5fw47j00h26wbsfly0k1zj";
  };
  meta = {
    inherit version;
    description = ''A multiplayer X11 space combat game'';
    homepage = http://xpilot.sf.net/;
    license = stdenv.lib.licenses.gpl2Plus ;
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.linux;
  };
}
