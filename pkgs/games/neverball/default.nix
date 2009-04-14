{stdenv, fetchurl, SDL, mesa, libpng, libjpeg, SDL_ttf, libvorbis, gettext} :

stdenv.mkDerivation {
  name = "neverball-1.5.0";
  src = fetchurl {
    url = http://neverball.org/neverball-1.5.0.tar.gz;
    sha256 = "8e6f6946cf2b08c13e4956a14f46d74c5a40735965f8fa876668c52d1877ec6a";
  };

  buildInputs = [ SDL mesa libpng libjpeg SDL_ttf libvorbis gettext ];

  dontPatchElf = true;

  patchPhase = ''
    sed -i -e 's@\./data@'$out/data@ share/base_config.h
    sed -i -e 's@\./locale@'$out/locale@ share/base_config.h
    sed -i -e 's@-lvorbisfile@-lvorbisfile -lX11 -lgcc_s@' Makefile
  '';

  installPhase = ''
    ensureDir $out/bin $out
    cp -R data locale $out
    cp neverball $out/bin
    cp neverputt $out/bin
    cp mapc $out/bin
  '';

  meta = {
    homepage = http://neverball.org/;
    description = "Tilt the floor to roll a ball";
    license = "GPL";
  };
}
