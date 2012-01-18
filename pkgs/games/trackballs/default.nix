{ stdenv, fetchurl, SDL, mesa, SDL_ttf, gettext, zlib, SDL_mixer, SDL_image, guile
, debug ? false }:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "trackballs-1.1.4";
  
  src = fetchurl {
    url = mirror://sourceforge/trackballs/trackballs-1.1.4.tar.gz;
    sha256 = "19ilnif59sxa8xmfisk90wngrd11pj8s86ixzypv8krm4znbm7a5";
  };

  buildInputs = [ zlib mesa SDL SDL_ttf SDL_mixer SDL_image guile gettext ];

  CFLAGS = optionalString debug "-g -O0";
  CXXFLAGS = CFLAGS;
  dontStrip = debug;
  postUnpack = optionalString debug
    "mkdir -p $out/src; cp -R * $out/src ; cd $out/src";

  NIX_CFLAGS_COMPILE = "-iquote ${SDL}/include/SDL";
  configureFlags = optionalString debug "--enable-debug";

  patchPhase = ''
    sed -i -e 's/images icons music/images music/' share/Makefile.in
  '';

  meta = {
    homepage = http://trackballs.sourceforge.net/;
    description = "3D Marble Madness clone";
  };
}
