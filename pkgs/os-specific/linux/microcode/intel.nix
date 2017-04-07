{ stdenv, fetchurl, libarchive }:

stdenv.mkDerivation rec {
  name = "microcode-intel-${version}";
  version = "20161104";

  src = fetchurl {
    url = "http://downloadmirror.intel.com/26400/eng/microcode-${version}.tgz";
    sha256 = "1lg3bvznvwcxf66k038c57brkcxfva8crpnzj5idmczr5yk4q5bh";
  };

  buildInputs = [ libarchive ];

  sourceRoot = ".";

  buildPhase = ''
    gcc -O2 -Wall -o intel-microcode2ucode ${./intel-microcode2ucode.c}
    ./intel-microcode2ucode microcode.dat
  '';

  installPhase = ''
    mkdir -p $out kernel/x86/microcode
    mv microcode.bin kernel/x86/microcode/GenuineIntel.bin
    echo kernel/x86/microcode/GenuineIntel.bin | bsdcpio -o -H newc -R 0:0 > $out/intel-ucode.img
  '';

  meta = with stdenv.lib; {
    homepage = http://www.intel.com/;
    description = "Microcode for Intel processors";
    license = licenses.unfreeRedistributableFirmware;
    maintainers = with maintainers; [ wkennington ];
    platforms = platforms.linux;
  };
}
