{ lib, stdenv, fetchFromGitHub, libarchive, iucode-tool }:

stdenv.mkDerivation rec {
  pname = "microcode-intel";
  version = "20220207";

  src = fetchFromGitHub {
    owner = "intel";
    repo = "Intel-Linux-Processor-Microcode-Data-Files";
    rev = "microcode-${version}";
    sha256 = "sha256-yNHYAf8AX8C8iSaFWa6u7knUryaUgvI6nIH9jkD4jjw=";
  };

  nativeBuildInputs = [ iucode-tool libarchive ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out kernel/x86/microcode
    iucode_tool -w kernel/x86/microcode/GenuineIntel.bin intel-ucode/
    echo kernel/x86/microcode/GenuineIntel.bin | bsdcpio -o -H newc -R 0:0 > $out/intel-ucode.img

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "http://www.intel.com/";
    description = "Microcode for Intel processors";
    license = licenses.unfreeRedistributableFirmware;
    platforms = platforms.linux;
    maintainers = with maintainers; [ ];
  };
}
