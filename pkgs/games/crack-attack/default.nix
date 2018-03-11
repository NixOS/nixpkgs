{ stdenv, fetchurl, pkgconfig, gtk2, freeglut, SDL, libGLU_combined, libXi, libXmu}:

stdenv.mkDerivation {
  name = "crack-attack-1.1.14";

  src = fetchurl {
    url = mirror://savannah/crack-attack/crack-attack-1.1.14.tar.gz;
    sha256 = "1sakj9a2q05brpd7lkqxi8q30bccycdzd96ns00s6jbxrzjlijkm";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ gtk2 freeglut SDL libGLU_combined libXi libXmu ];

  hardeningDisable = [ "format" ];

  meta = {
    description = "A fast-paced puzzle game inspired by the classic Super NES title Tetris Attack!";
    homepage = http://www.nongnu.org/crack-attack/;
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.piotr ];
  };

  patches = [
    ./crack-attack-1.1.14-gcc43.patch
    ./crack-attack-1.1.14-glut.patch
  ];
}
