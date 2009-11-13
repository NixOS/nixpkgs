{stdenv, fetchurl, SDL, mesa, libpng, libjpeg, SDL_ttf, libvorbis, gettext,
physfs} :

stdenv.mkDerivation rec {
  name = "neverball-1.5.4";
  src = fetchurl {
    url = "http://neverball.org/${name}.tar.gz";
    sha256 = "19hdgdmv20y56xvbj4vk0zdmyaa8kv7df85advkchw7cdsgwlcga";
  };

  buildInputs = [ SDL mesa libpng libjpeg SDL_ttf libvorbis gettext physfs];

  dontPatchElf = true;

  patchPhase = ''
    sed -i -e 's@\./data@'$out/data@ share/base_config.h Makefile
    sed -i -e 's@\./locale@'$out/locale@ share/base_config.h Makefile
    sed -i -e 's@-lvorbisfile@-lvorbisfile -lX11 -lgcc_s@' Makefile
  '';

  # The map generation code requires a writable HOME
  preConfigure = "export HOME=$TMPDIR";

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
