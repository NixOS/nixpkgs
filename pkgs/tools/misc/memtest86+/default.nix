{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation (finalAttrs: {
  pname = "memtest86+";
  version = "6.01";

  src = fetchFromGitHub {
    owner = "memtest86plus";
    repo = "memtest86plus";
    rev = "v${finalAttrs.version}";
    hash = "sha256-BAY8hR8Sl9Hp9Zps0INL43cNqJwXX689m9rfa4dHrqs=";
  };

  # Binaries are booted directly by BIOS/UEFI or bootloader
  # and should not be patched/stripped
  dontPatchELF = true;
  dontStrip = true;

  passthru.efi = "${finalAttrs.finalPackage}/memtest.efi";

  preBuild = ''
    cd ${if stdenv.isi686 then "build32" else "build64"}
  '';

  installPhase = ''
    install -Dm0444 -t $out/ memtest.bin memtest.efi
  '';

  meta = {
    homepage = "https://www.memtest.org/";
    description = "A tool to detect memory errors";
    license = lib.licenses.gpl2;
    platforms = [ "x86_64-linux" "i686-linux" ];
    maintainers = [ lib.maintainers.LunNova ];
  };
})
