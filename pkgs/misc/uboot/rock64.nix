{ lib, buildUBoot, fetchFromGitHub, armTrustedFirmwareRK3328 }: buildUBoot rec {
  name = "uboot-${defconfig}-${version}";
  version = "2018.01";

  src = fetchFromGitHub {
    owner = "ayufan-rock64";
    repo = "linux-u-boot";
    rev = "19e31fac0dee3c4f6b2ea4371e4321f79db0f495";
    sha256 = "1vmv7q9yafsc0zivd0qdfmf930dvhzkf4a3j6apxxgx9g10wgwrg";
  };

  extraMakeFlags = [ "BL31=${armTrustedFirmwareRK3328}/bl31.elf" "u-boot.itb" "all" ];
  postBuild = ''
    ./tools/mkimage -n rk3328 -T rksd -d tpl/u-boot-tpl.bin idbloader.img
    cat spl/u-boot-spl.bin >> idbloader.img
    dd if=u-boot.itb of=idbloader.img seek=448 conv=notrunc
  '';

  defconfig = "rock64-rk3328_defconfig";
  filesToInstall = [ "spl/u-boot-spl.bin" "tpl/u-boot-tpl.bin" "u-boot.itb" "idbloader.img"];

  extraMeta = {
    maintainers = [ lib.maintainers.lopsided98 ];
    platforms = ["aarch64-linux"];
  };
}
