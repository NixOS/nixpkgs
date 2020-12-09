{ stdenv, fetchFromGitHub, libarchive, iucode-tool }:

stdenv.mkDerivation rec {
  pname = "microcode-intel";
  version = "20201118";

  src = fetchFromGitHub {
    owner = "intel";
    repo = "Intel-Linux-Processor-Microcode-Data-Files";
    rev = "microcode-${version}";
    sha256 = "1xs3f2rbfqnpz9qs7a1kl363qdyb8fybmmyd37v573clqf7l4lgg";
  };

  nativeBuildInputs = [ iucode-tool libarchive ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out kernel/x86/microcode
    iucode_tool -w kernel/x86/microcode/GenuineIntel.bin intel-ucode/
    echo kernel/x86/microcode/GenuineIntel.bin | bsdcpio -o -H newc -R 0:0 > $out/intel-ucode.img

    runHook postInstall
  '';

  meta = with stdenv.lib; {
    homepage = "http://www.intel.com/";
    description = "Microcode for Intel processors";
    license = licenses.unfreeRedistributableFirmware;
    platforms = platforms.linux;
    maintainers = with maintainers; [ andir ];
  };
}
