{stdenv, fetchurl, which, pkgconfig, SDL, gtk, mesa, SDL_ttf}:

stdenv.mkDerivation {
  name = "mupen64plus-1.99.5";
  src = fetchurl {
    url = https://mupen64plus.googlecode.com/files/mupen64plus-bundle-src-1.99.5.tar.gz;
    sha1 = "ca80ae446c9591e272e3ec93f0a2a8b01cfcd34e";
  };
  
  buildInputs = [ which pkgconfig SDL gtk mesa SDL_ttf ];
  
  buildPhase = "./m64p_build.sh PREFIX=$out COREDIR=$out/lib/ PLUGINDIR=$out/lib/mupen64plus/ SHAREDIR=$out/share/mupen64plus/";
  installPhase = "./m64p_install.sh PREFIX=$out";
  
  meta = {
    description = "A Nintendo 64 Emulator";
    license = "GPLv2+";
    homepage = http://code.google.com/p/mupen64plus;
    maintainers = [ stdenv.lib.maintainers.sander ];
  };
}
