{ stdenv, fetchFromGitHub, python3, libftdi }:

stdenv.mkDerivation rec {
  name = "icestorm-${version}";
  version = "2017.08.31";

  src = fetchFromGitHub {
    owner = "cliffordwolf";
    repo = "icestorm";
    rev = "8354bc6086f11002cc58497f91f43200a09c13a9";
    sha256 = "0mg6sp5ymdxmkyzmssyavsjicw0z74bn4lv1jqwxjnmynw5l0f9b";
  };

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
    maintainers = [ stdenv.lib.maintainers.shell ];
    platforms = stdenv.lib.platforms.linux;
  };
}
