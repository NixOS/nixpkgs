{ stdenv, fetchFromGitHub, python3, libftdi, pkgconfig }:

stdenv.mkDerivation rec {
  name = "icestorm-${version}";
  version = "2017.12.06";

  src = fetchFromGitHub {
    owner  = "cliffordwolf";
    repo   = "icestorm";
    rev    = "14b44ca866665352e7146778bb932e45b5fdedbd";
    sha256 = "18qy7gylnydgzmqry1b4r0ilm6lkjdcyn0wj03syxdig9dbjiacm";
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
