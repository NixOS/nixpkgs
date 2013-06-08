{ stdenv, fetchurl, kernelDev, perl, makeWrapper }:

# BLCR 0.8.4 works for kernel version up to 2.6.38 (including 2.6.38.x)
# BLCR 0.8.5 should works for kernel version up to 3.7.1

assert stdenv.isLinux;
assert builtins.compareVersions "3.7.2" kernelDev.version == 1;

stdenv.mkDerivation {
  name = "blcr_${kernelDev.version}-0.8.5";

  src = fetchurl {
    url = http://crd.lbl.gov/assets/Uploads/FTG/Projects/CheckpointRestart/downloads/blcr-0.8.5.tar.gz;
    sha256 = "01a809nfbr715pnidlslv55pxadm3021l97p98zkqy8chyrnkjb0";
  };

  buildInputs = [ perl makeWrapper ];

  preConfigure = ''
    configureFlagsArray=(
      --with-linux=${kernelDev}/lib/modules/${kernelDev.modDirVersion}/build
      --with-kmod-dir=$out/lib/modules/${kernelDev.modDirVersion}
      --with-system-map=${kernelDev}/System.map
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
