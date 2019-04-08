{ lib, buildUBoot, fetchFromGitHub, armTrustedFirmwareRK3328 }: let
  rkbin = fetchFromGitHub {
    owner = "ayufan-rock64";
    repo = "rkbin";
    rev = "af17d09dee19b41f4f01e1722eaf6911fb296245";
    sha256 = "189f7h6wj2yrcc5ga103jnyysykf9j3j9p1vcy7791bxwxqxnggf";
  };
in buildUBoot rec {
  version = "2017.09";

  src = fetchFromGitHub {
    owner = "ayufan-rock64";
    repo = "linux-u-boot";
    rev = "d646df03ace3bd191e24361944ce1c7ef3c8744c";
    sha256 = "0gclcd034qfhfbabrdqmky08i0hlwmn63n0zg6mndplms5qpcx75";
  };

  extraMakeFlags = [ "BL31=${armTrustedFirmwareRK3328}/bl31.elf" "u-boot.itb" "all" ];

  # Close to being blob free, but the U-Boot TPL causes the kernel to hang after a few minutes
  postBuild = ''
    ./tools/mkimage -n rk3328 -T rksd -d ${rkbin}/rk33/rk3328_ddr_786MHz_v1.13.bin idbloader.img
    cat spl/u-boot-spl.bin >> idbloader.img
    dd if=u-boot.itb of=idbloader.img seek=448 conv=notrunc
  '';

  defconfig = "rock64-rk3328_defconfig";
  filesToInstall = [ "spl/u-boot-spl.bin" "tpl/u-boot-tpl.bin" "u-boot.itb" "idbloader.img"];

  extraMeta = with lib; {
    maintainers = [ maintainers.lopsided98 ];
    platforms = ["aarch64-linux"];
    # Because of the TPL blob
    license = licenses.unfreeRedistributableFirmware;
  };
}
