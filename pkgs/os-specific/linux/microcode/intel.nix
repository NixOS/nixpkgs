{ stdenv, fetchurl, libarchive, iucode-tool }:

stdenv.mkDerivation rec {
  name = "microcode-intel-${version}";
  version = "20180807a";

  src = fetchurl {
    url = "https://downloadmirror.intel.com/28087/eng/microcode-${version}.tgz";
    sha256 = "0dw1akgzdqk95pwmc8gfdmv7kabw9pn4c67f076bcbn4krliias6";
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
    platforms = platforms.linux;
  };
}
