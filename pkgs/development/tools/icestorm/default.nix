{ stdenv, fetchFromGitHub, python3, libftdi }:

stdenv.mkDerivation rec {
  name = "icestorm-${version}";
  version = "2015.12.29";

  src = fetchFromGitHub {
    owner = "cliffordwolf";
    repo = "icestorm";
    rev = "7852514c2cde208da87b62777b2c5e482092f50d";
    sha256 = "1ya1nk5h28hjdmd8jdrlfiayr2434rnvi133gs1p0ay21qb3iwfz";
  };

  buildInputs = [ python3 libftdi ];
  preBuild = ''
    makeFlags="DESTDIR=$out $makeFlags"
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
