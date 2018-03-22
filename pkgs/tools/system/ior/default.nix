{ stdenv, fetchurl, openmpi, automake, autoconf, perl }:

let
  version = "3.0.1";
  sha256 = "039rh4z3lsj4vqjsqgakk0b7dkrdrkkzj0p1cjikpc9gn36zpghc";
in

stdenv.mkDerivation rec {
  name = "ior-${version}";

  src = fetchurl {
    url = "https://github.com/LLNL/ior/archive/${version}.tar.gz";
    inherit sha256;
  };

  buildInputs = [ openmpi automake autoconf perl ];

  enableParallelBuilding = true;

  preConfigure = "./bootstrap";

  meta = with stdenv.lib; {
    homepage = http://www.nersc.gov/users/computational-systems/cori/nersc-8-procurement/trinity-nersc-8-rfp/nersc-8-trinity-benchmarks/ior/;
    description = "Parallel file system I/O performance test";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ bzizou ];
  };
}
