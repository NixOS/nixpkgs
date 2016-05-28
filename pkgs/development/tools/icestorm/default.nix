{ stdenv, fetchFromGitHub, python3, libftdi }:

stdenv.mkDerivation rec {
  name = "icestorm-${version}";
  version = "2016.05.21";

  src = fetchFromGitHub {
    owner = "cliffordwolf";
    repo = "icestorm";
    rev = "fb67695a883b29ca670b43ed2733eca9ca161e4d";
    sha256 = "0zsjpz49qr09g33nz4nfi1inshg37y5zdxnv6f8gkwq7x948rh3z";
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
  };
}
