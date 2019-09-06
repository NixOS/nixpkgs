{ lib, buildUBoot, fetchFromGitHub }: let
  rkbin = fetchFromGitHub {
    owner = "ayufan-rock64";
    repo = "rkbin";
    rev = "f79a708978232a2b6b06c2e4173c5314559e0d3a";
    sha256 = "0h7xm4ck3p3380c6bqm5ixrkxwcx6z5vysqdwvfa7gcqx5d6x5zz";
  };
in buildUBoot {
  version = "2017.09";

  src = fetchFromGitHub {
    owner = "ayufan-rock64";
    repo = "linux-u-boot";
    rev = "56bd9582537a70c30387de3ce9038a56d2c77bfe";
    sha256 = "1m0k8ivzhmg9y4x0k7fz7y71pgblzxy81m6x32iivz5kjnxdnv4i";
  };

  extraPatches = [ ./rock64-fdt-dtc-compatibility.patch ];

  # Upstream ATF hangs in SPL
  extraMakeFlags = [ "BL31=${rkbin}/rk33/rk3399_bl31_v1.25.elf" "u-boot.itb" "all" ];

  postBuild = ''
    ./tools/mkimage -n rk3399 -T rksd -d ${rkbin}/rk33/rk3399_ddr_933MHz_v1.19.bin idbloader.img
    cat spl/u-boot-spl.bin >> idbloader.img
    dd if=u-boot.itb of=idbloader.img seek=448 conv=notrunc
  '';

  defconfig = "rockpro64-rk3399_defconfig";
  filesToInstall = [ "spl/u-boot-spl.bin" "u-boot.itb" "idbloader.img"];

  extraMeta = with lib; {
    maintainers = [ maintainers.lopsided98 ];
    platforms = ["aarch64-linux"];
    # Because of the TPL and ATF (BL31) blobs
    license = licenses.unfreeRedistributableFirmware;
  };
}
