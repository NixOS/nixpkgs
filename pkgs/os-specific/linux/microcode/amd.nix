{ stdenv, firmwareLinuxNonfree, libarchive }:

stdenv.mkDerivation rec {
  name = "amd-ucode-${firmwareLinuxNonfree.version}";

  src = firmwareLinuxNonfree;

  sourceRoot = ".";

  buildInputs = [ libarchive ];

  buildPhase = ''
    mkdir -p kernel/x86/microcode
    find ${firmwareLinuxNonfree}/lib/firmware/amd-ucode -name \*.bin \
      -exec sh -c 'cat {} >> kernel/x86/microcode/AuthenticAMD.bin' \;
  '';

  installPhase = ''
    mkdir -p $out
    echo kernel/x86/microcode/AuthenticAMD.bin | bsdcpio -o -H newc -R 0:0 > $out/amd-ucode.img
  '';

  meta = with stdenv.lib; {
    description = "AMD Processor microcode patch";
    homepage = http://www.amd64.org/support/microcode.html;
    license = licenses.unfreeRedistributableFirmware;
    platforms = platforms.linux;
  };
}
