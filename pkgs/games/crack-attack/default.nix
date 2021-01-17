{ lib, stdenv, fetchurl, pkg-config, gtk2, freeglut, SDL, SDL_mixer, libGLU, libGL, libXi, libXmu }:

stdenv.mkDerivation {
  name = "crack-attack-1.1.14";

  src = fetchurl {
    url = "mirror://savannah/crack-attack/crack-attack-1.1.14.tar.gz";
    sha256 = "1sakj9a2q05brpd7lkqxi8q30bccycdzd96ns00s6jbxrzjlijkm";
  };

  patches = [
    ./crack-attack-1.1.14-gcc43.patch
    ./crack-attack-1.1.14-glut.patch
  ];

  configureFlags = [
    "--enable-sound=yes"
    "--prefix=${placeholder "out"}"
    "--datadir=${placeholder "out"}/share"
  ];

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ gtk2 freeglut SDL SDL_mixer libGLU libGL libXi libXmu ];

  hardeningDisable = [ "format" ];
  enableParallelBuilding = true;

  meta = {
    description = "A fast-paced puzzle game inspired by the classic Super NES title Tetris Attack!";
    homepage = "https://www.nongnu.org/crack-attack/";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.piotr ];
  };
}
