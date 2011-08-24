{ stdenv, fetchurl, kernel, perl, makeWrapper }:

assert stdenv.isLinux;

stdenv.mkDerivation {
  name = "blcr-0.8.3-${kernel.version}";

  src = fetchurl {
    url = https://ftg.lbl.gov/assets/projects/CheckpointRestart/downloads/blcr-0.8.3.tar.gz;
    sha256 = "c8243c9a7a215d4fc4e8f2199045711cf711a6f2e0b39a94413478ffae110eac";
  };

  buildInputs = [ perl makeWrapper ];

  preConfigure = ''
    configureFlagsArray=(
      --with-linux=${kernel}/lib/modules/${kernel.modDirVersion}/build
      --with-kmod-dir=$out/lib/modules/${kernel.modDirVersion}
      --with-system-map=${kernel}/System.map
    )
  '';

  postInstall = ''
    for prog in "$out/bin/"*
    do
      wrapProgram "$prog" --prefix LD_LIBRARY_PATH ":" "$out/lib"
    done
  '';
      
  meta = {
    description = "Berkeley Lab Checkpoint/Restart for Linux (BLCR)";
    homepage = https://ftg.lbl.gov/projects/CheckpointRestart/;
    license = "GPL2";
  };
}
