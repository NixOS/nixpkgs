{ stdenv, fetchurl, libarchive, iucode-tool }:

stdenv.mkDerivation rec {
  name = "microcode-intel-${version}";
  version = "20180807";

  src = fetchurl {
    url = "https://downloadmirror.intel.com/28039/eng/microcode-${version}.tgz";
    sha256 = "0h4ygwx5brnrjz8v47aikrwhf0q3jhizxmzcii4bdjg64zffiy99";
  };

  nativeBuildInputs = [ iucode-tool libarchive ];

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall

    mkdir -p $out kernel/x86/microcode
    iucode_tool -w kernel/x86/microcode/GenuineIntel.bin intel-ucode/
    echo kernel/x86/microcode/GenuineIntel.bin | bsdcpio -o -H newc -R 0:0 > $out/intel-ucode.img

    runHook postInstall
  '';

  meta = with stdenv.lib; {
    homepage = http://www.intel.com/;
    description = "Microcode for Intel processors";
    license = licenses.unfreeRedistributableFirmware;
    maintainers = with maintainers; [ wkennington ];
    platforms = platforms.linux;
  };
}
