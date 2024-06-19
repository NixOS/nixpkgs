{ lib, stdenv, fetchurl, libX11, libSM, SDL, libGLU, libGL, expat, SDL_ttf
, SDL_image, zlib, libXxf86misc }:
stdenv.mkDerivation rec {
  pname = "xpilot-ng";
  version = "4.7.3";
  src = fetchurl {
    url = "mirror://sourceforge/xpilot/xpilot_ng/${pname}-${version}/${pname}-${version}.tar.gz";
    sha256 = "02a7pnp88kh88fzda5q8mzlckk6y9r5fw47j00h26wbsfly0k1zj";
  };
  buildInputs = [
    libX11 libSM SDL SDL_ttf SDL_image libGLU libGL expat zlib libXxf86misc
  ];
  meta = with lib; {
    description = "Multiplayer X11 space combat game";
    homepage = "http://xpilot.sf.net/";
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.raskin ];
    platforms = platforms.linux;
  };
}
