{ lib, stdenv, fetchurl, pkg-config, gtk2, libglut, SDL, SDL_mixer, libGLU, libGL, libXi, libXmu }:

stdenv.mkDerivation rec {
  pname = "crack-attack";
  version = "1.1.14";

  src = fetchurl {
    url = "mirror://savannah/crack-attack/crack-attack-${version}.tar.gz";
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
  buildInputs = [ gtk2 libglut SDL SDL_mixer libGLU libGL libXi libXmu ];

  hardeningDisable = [ "format" ];
  enableParallelBuilding = true;

  meta = {
    description = "Fast-paced puzzle game inspired by the classic Super NES title Tetris Attack!";
    mainProgram = "crack-attack";
    homepage = "https://www.nongnu.org/crack-attack/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    maintainers = [ ];
  };
}
