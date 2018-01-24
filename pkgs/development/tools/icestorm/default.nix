{ stdenv, fetchFromGitHub, python3, libftdi, pkgconfig }:

stdenv.mkDerivation rec {
  name = "icestorm-${version}";
  version = "2018.01.10";

  src = fetchFromGitHub {
    owner  = "cliffordwolf";
    repo   = "icestorm";
    rev    = "bca8c3c88f5707213a6cc55ec7b06b576ab98809";
    sha256 = "00g1xd70dlgvyfyk5ivj71dpk0vzx3xka60f6x3hm4frl9ahyhj7";
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
