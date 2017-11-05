{ stdenv, fetchFromGitHub, python3, libftdi }:

stdenv.mkDerivation rec {
  name = "icestorm-${version}";
  version = "2017.11.05";

  src = fetchFromGitHub {
    owner  = "cliffordwolf";
    repo   = "icestorm";
    rev    = "3ba18d001754de563ab0baa2a1c8eecbe63ef121";
    sha256 = "1c7yv91xi4vx0130xn2zq74gfjbf7fhm2q4fma9xgwj5xpdy8rmn";
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
    maintainers = with stdenv.lib.maintainers; [ shell thoughtpolice ];
    platforms = stdenv.lib.platforms.linux;
  };
}
