{stdenv, fetchurl, SDL, mesa, SDL_ttf, gettext, zlib, SDL_mixer, SDL_image, guile,
  debug ? false } :

stdenv.mkDerivation rec {
  name = "trackballs-1.1.4";
  src = fetchurl {
    url = mirror://sourceforge/trackballs/trackballs-1.1.4.tar.gz;
    sha256 = "19ilnif59sxa8xmfisk90wngrd11pj8s86ixzypv8krm4znbm7a5";
  };

  buildInputs = [ zlib mesa SDL SDL_ttf SDL_mixer SDL_image guile gettext ];

  CFLAGS = if debug then "-g -O0" else null;
  CXXFLAGS = CFLAGS;
  NIX_STRIP_DEBUG = if debug then "0" else "1";
  dontStrip = if debug then true else false;
  postUnpack = if debug then
    "ensureDir $out/src; cp -R * $out/src ; cd $out/src"
    else null;

  NIX_CFLAGS_COMPILE="-iquote ${SDL}/include/SDL";
  configureFlags = if debug then "--enable-debug" else null;

  patchPhase = ''
    sed -i -e 's/images icons music/images music/' share/Makefile.in
  '';

  meta = {
    homepage = http://trackballs.sourceforge.net/;
    description = "3D Marble Madness clone";
  };
}
