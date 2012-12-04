{stdenv, fetchurl
, zlib, jam, pkgconfig, gettext, libxml2, libxslt, xproto, libX11, mesa, SDL
, SDL_mixer, SDL_image, SDL_ttf, SDL_gfx, physfs
}:
let s = # Generated upstream information
  rec {
    baseName="lincity";
    version="2.0";
    name="lincity-2.0";
    hash="01k6n304qj0z5zmqr49gqirp0jmx2b0cpisgkxk1ga67vyjhdcm6";
    url="http://download.berlios.de/lincity-ng/lincity-ng-2.0.tar.bz2";
    sha256="01k6n304qj0z5zmqr49gqirp0jmx2b0cpisgkxk1ga67vyjhdcm6";
  };
  buildInputs = [zlib jam pkgconfig gettext libxml2 libxslt xproto libX11 mesa 
    SDL SDL_mixer SDL_image SDL_ttf SDL_gfx physfs];
in 
stdenv.mkDerivation rec {
  inherit (s) name version;
  src = fetchurl {
    inherit (s) url sha256;
  };

  inherit buildInputs;

  buildPhase = "jam";
  installPhase="jam install";

  meta = {
    documentation = ''City building game'';
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [stdenv.lib.maintainers.raskin];
    inherit (s) version;
  };
}
