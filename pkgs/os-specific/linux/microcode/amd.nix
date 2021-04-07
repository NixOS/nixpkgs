{ lib, stdenv, firmwareLinuxNonfree, libarchive }:

stdenv.mkDerivation {
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

  meta = with lib; {
    description = "AMD Processor microcode patch";
    homepage = "https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git";
    license = licenses.unfreeRedistributableFirmware;
    platforms = platforms.linux;
  };
}
