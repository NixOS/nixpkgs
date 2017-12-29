{ stdenv, fetchurl, libarchive }:

stdenv.mkDerivation rec {
  name = "microcode-intel-${version}";
  version = "20171117";

  src = fetchurl {
    url = "https://downloadmirror.intel.com/27337/eng/microcode-${version}.tgz";
    sha256 = "1p14ypbg28bdkbza6dx6dpjrdr5p13vmgrh2cw0y1v2qzalivgck";
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
