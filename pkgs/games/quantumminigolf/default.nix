{stdenv, fetchurl, fftwSinglePrec, freetype, SDL, SDL_ttf}:
let
  s = # Generated upstream information
  rec {
    baseName="quantumminigolf";
    version="1.1.1";
    name="${baseName}-${version}";
    hash="16av7fk0irhi5nd7y9h9vhb0kf0dk12p6976ai3f60m99qdd8wk3";
    url="mirror://sourceforge/project/quantumminigolf/quantumminigolf/1.1.1/quantumminigolf-1.1.1.src.tar.gz";
    sha256="16av7fk0irhi5nd7y9h9vhb0kf0dk12p6976ai3f60m99qdd8wk3";
  };
  buildInputs = [
    fftwSinglePrec freetype SDL SDL_ttf
  ];
in
stdenv.mkDerivation {
  inherit (s) name version;
  inherit buildInputs;
  src = fetchurl {
    inherit (s) url sha256;
  };
  preBuild = ''
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -I${SDL.dev}/include/SDL"

    sed -re 's@"(gfx|fonts|tracks)/@"'"$out"'/share/quantumminigolf/\1/@g' -i *.cpp
  '';
  installPhase = ''
    mkdir -p "$out"/{share/doc,share/quantumminigolf,bin}
    cp README THANKS LICENSE "$out/share/doc"
    cp -r fonts gfx tracks "$out/share/quantumminigolf"
    cp quantumminigolf "$out/bin"
  '';
  meta = {
    inherit (s) version;
    description = ''Quantum mechanics-based minigolf-like game'';
    license = stdenv.lib.licenses.gpl2 ;
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.linux;
  };
}
