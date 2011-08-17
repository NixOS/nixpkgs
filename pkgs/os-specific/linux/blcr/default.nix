{ stdenv, fetchurl, kernel, perl }:

assert stdenv.isLinux;

stdenv.mkDerivation {
  name = "blcr-0.8.3-${kernel.version}";

  src = fetchurl {
    url = https://ftg.lbl.gov/assets/projects/CheckpointRestart/downloads/blcr-0.8.3.tar.gz;
    sha256 = "c8243c9a7a215d4fc4e8f2199045711cf711a6f2e0b39a94413478ffae110eac";
  };

  buildInputs = [ perl ];

  preConfigure = ''
    configureFlagsArray=(
      --with-linux=${kernel}/lib/modules/${kernel.version}/build
      --with-kmod-dir=$out/lib/modules/${kernel.version}
      --with-system-map=${kernel}/System.map
    )
  '';
      
  meta = {
    description = "Berkeley Lab Checkpoint/Restart for Linux (BLCR)";
    homepage = https://ftg.lbl.gov/projects/CheckpointRestart/;
    license = "GPL2";
  };
}
