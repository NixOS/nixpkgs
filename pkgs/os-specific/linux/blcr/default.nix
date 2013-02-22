{ stdenv, fetchurl, kernel, perl, makeWrapper }:

# BLCR 0.8.4 works for kernel version up to 2.6.38 (including 2.6.38.x)
# BLCR 0.8.5_beta3 should works for kernel version up to 3.7.1

assert stdenv.isLinux;
#assert builtins.compareVersions "2.6.39" kernel.version == 1;
assert builtins.compareVersions "3.7.2" kernel.version == 1;

stdenv.mkDerivation {
  name = "blcr_${kernel.version}-0.8.5pre3";

  src = fetchurl {
    url = https://upc-bugs.lbl.gov/blcr-dist/blcr-0.8.5_b3.tar.gz;
    sha256 = "1xp2k140w79zqbnfnb2q7z91hv15d5a6p39zdc97f9pfxmyyc8fn";
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
