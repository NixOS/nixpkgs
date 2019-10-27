{ stdenv, fetchFromGitHub, fetchurl, cmake, pkgconfig, SDL, SDL_image, SDL_mixer, SDL_net, SDL_ttf, libpng, librsvg, libxml2 }:

stdenv.mkDerivation rec {
  version = "0.1.1";
  pname = "t4kcommon";

  src = fetchFromGitHub {
    owner = "tux4kids";
    repo = "t4kcommon";
    rev = "upstream/${version}";
    sha256 = "13q02xpmps9qg8zrzzy2gzv4a6afgi28lxk4z242j780v0gphchp";
  };

  patches = [
    # patch from debian to support libpng16 instead of libpng12
    (fetchurl {
      url = "https://salsa.debian.org/tux4kids-pkg-team/t4kcommon/raw/f7073fa384f5a725139f54844e59b57338b69dc7/debian/patches/libpng16.patch";
      sha256 = "1lcpkdy5gvxgljg1vkrxych74amq0gramb1snj2831dam48is054";
    })
  ];

  nativeBuildInputs = [ cmake pkgconfig ];
  buildInputs = [ SDL SDL_image SDL_mixer SDL_net SDL_ttf libpng librsvg libxml2 ];

  meta = with stdenv.lib; {
    description = "A library of code shared between tuxmath and tuxtype.";
    homepage = https://github.com/tux4kids/t4kcommon;
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.aanderse ];
    platforms = platforms.linux;
  };
}
