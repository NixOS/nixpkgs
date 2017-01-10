{ stdenv, fetchFromGitHub, python3, libftdi }:

stdenv.mkDerivation rec {
  name = "icestorm-${version}";
  version = "2016.11.01";

  src = fetchFromGitHub {
    owner = "cliffordwolf";
    repo = "icestorm";
    rev = "01b9822638d60e048c295d005257daa4c147761f";
    sha256 = "088wnf55m9ii98w8j7qc99spq95y19xw4fnnw9mxi7cfkxxggsls";
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
