{stdenv, fetchurl, which, pkgconfig, SDL, gtk, mesa, SDL_ttf}:

stdenv.mkDerivation {
  name = "mupen64plus-1.5";
  src = fetchurl {
    url = http://mupen64plus.googlecode.com/files/Mupen64Plus-1-5-src.tar.gz;
    sha256 = "0gygfgyr2sg4yx77ijk133d1ra0v1yxi4xjxrg6kp3zdjmhdmcjq";
  };
  
  buildInputs = [ which pkgconfig SDL gtk mesa SDL_ttf ];
  
  preConfigure = ''
    # Some C++ incompatibility fixes
    sed -i -e 's|char \* extstr = strstr|const char * extstr = strstr|' glide64/Main.cpp
    sed -i -e 's|char \* extstr = strstr|const char * extstr = strstr|' glide64/Combine.cpp

    # Fix some hardcoded paths
    sed -i -e "s|/usr/local|$out|g" main/main.c
  '';
  
  buildPhase = "make all";
  installPhase = "PREFIX=$out make install";
}
