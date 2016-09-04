{ stdenv, fetchFromGitHub, python3, libftdi }:

stdenv.mkDerivation rec {
  name = "icestorm-${version}";
  version = "2016.08.18";

  src = fetchFromGitHub {
    owner = "cliffordwolf";
    repo = "icestorm";
    rev = "12b2295c9087d94b75e374bb205ae4d76cf17e2f";
    sha256 = "1mmzlqvap6w8n4qzv3idvy51arkgn03692ssplwncy3akjrbsd2b";
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
