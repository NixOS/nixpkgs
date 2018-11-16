{ stdenv, fetchurl, SDL2, libGL, libpng, libjpeg, SDL2_ttf, libvorbis, gettext
, physfs }:

stdenv.mkDerivation rec {
  name = "neverball-1.6.0";
  src = fetchurl {
    url = "https://neverball.org/${name}.tar.gz";
    sha256 = "184gm36c6p6vaa6gwrfzmfh86klhnb03pl40ahsjsvprlk667zkk";
  };

  buildInputs = [ libpng SDL2 libGL libjpeg SDL2_ttf libvorbis gettext physfs ];

  dontPatchElf = true;

  patchPhase = ''
    sed -i -e 's@\./data@'$out/share/neverball/data@ share/base_config.h Makefile
    sed -i -e 's@\./locale@'$out/share/neverball/locale@ share/base_config.h Makefile
    sed -i -e 's@-lvorbisfile@-lvorbisfile -lX11 -lgcc_s@' Makefile
  '';

  # The map generation code requires a writable HOME
  preConfigure = "export HOME=$TMPDIR";

  installPhase = ''
    mkdir -p $out/bin $out/share/neverball
    cp -R data locale $out/share/neverball
    cp neverball $out/bin
    cp neverputt $out/bin
    cp mapc $out/bin
  '';

  enableParallelBuilding = true;

  meta = {
    homepage = https://neverball.org/;
    description = "Tilt the floor to roll a ball";
    license = "GPL";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
