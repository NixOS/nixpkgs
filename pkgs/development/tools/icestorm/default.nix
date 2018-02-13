{ stdenv, fetchFromGitHub, python3, libftdi, pkgconfig }:

stdenv.mkDerivation rec {
  name = "icestorm-${version}";
  version = "2018.02.04";

  src = fetchFromGitHub {
    owner  = "cliffordwolf";
    repo   = "icestorm";
    rev    = "722790ad3cdb497e1b13cd1b4368d8380371eb37";
    sha256 = "0l04c6dshhhdcgqg1bdlw215wbn52fsg2fm2cvavhvf64c18lwd1";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ python3 libftdi ];
  preBuild = ''
    makeFlags="PREFIX=$out $makeFlags"
  '';

  meta = {
    description = "Documentation and tools for Lattice iCE40 FPGAs";
    longDescription = ''
      Project IceStorm aims at reverse engineering and
      documenting the bitstream format of Lattice iCE40
      FPGAs and providing simple tools for analyzing and
      creating bitstream files.
    '';
    homepage = http://www.clifford.at/icestorm/;
    license = stdenv.lib.licenses.isc;
    maintainers = with stdenv.lib.maintainers; [ shell thoughtpolice ];
    platforms = stdenv.lib.platforms.linux;
  };
}
