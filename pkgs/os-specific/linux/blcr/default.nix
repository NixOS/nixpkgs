{ stdenv, fetchurl, kernel, perl, makeWrapper }:

assert stdenv.isLinux;

stdenv.mkDerivation {
  name = "blcr-0.8.4-${kernel.version}";

  src = fetchurl {
    url = https://ftg.lbl.gov/assets/projects/CheckpointRestart/downloads/blcr-0.8.4.tar.gz;
    sha256 = "d851da66627d9212ac37bc9ea2aba40008ff2dc51d45dbd395ca2e403c3d78cf";
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
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [
      z77z
    ];
  };
}
