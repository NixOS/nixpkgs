{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation (finalAttrs: {
  pname = "memtest86+";
<<<<<<< HEAD
  version = "6.20";
=======
  version = "6.10";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "memtest86plus";
    repo = "memtest86plus";
    rev = "v${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-JzQJrAnPsa3GKNdy1PidOAZk7IQvRBi/YtmK2O9rWfM=";
=======
    hash = "sha256-f40blxh/On/mC4m+eLNeWzdYzYoYpFOSBndVnREx68U=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
