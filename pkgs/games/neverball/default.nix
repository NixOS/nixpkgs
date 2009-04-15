{stdenv, fetchurl, SDL, mesa, libpng, libjpeg, SDL_ttf, libvorbis, gettext} :

stdenv.mkDerivation {
  name = "neverball-1.5.1";
  src = fetchurl {
    url = http://neverball.org/neverball-1.5.1.tar.gz;
    sha256 = "0cqi6q829p1wx4471ab74xd7hmcvjg4fvj40rdc3342rvfqpijv5";
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
