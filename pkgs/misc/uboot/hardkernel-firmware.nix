{ stdenv
, lib
, fetchgit
, buildPackages
, pkgsCross
}:

let
  buildHardkernelFirmware = {
    version ? null
    , src ? null
    , name ? ""
    , filesToInstall
    , installDir ? "$out"
    , defconfig
    , extraMeta ? {}
    , ... } @ args: stdenv.mkDerivation ({
      pname = "uboot-hardkernel-firmware-${name}";

      nativeBuildInputs = [
        buildPackages.git
        buildPackages.hostname
        pkgsCross.arm-embedded.stdenv.cc
      ];

      depsBuildBuild = [
        buildPackages.gcc49
      ] ++ lib.optional (stdenv.buildPlatform != stdenv.hostPlatform) buildPackages.stdenv.cc
        ++ lib.optional (!stdenv.isAarch64) pkgsCross.aarch64-multiplatform.buildPackages.gcc49;

      postPatch = ''
        substituteInPlace Makefile --replace "/bin/pwd" "pwd"
      '';

      makeFlags = [
        "CROSS_COMPILE=${stdenv.cc.targetPrefix}"
        "CROSS_COMPILE_32=${pkgsCross.arm-embedded.stdenv.cc.targetPrefix}"
        "${defconfig}" "bl301.bin"
      ]
      ++ lib.optional (!stdenv.isAarch64) "CROSS_COMPILE=${pkgsCross.aarch64-multiplatform.stdenv.cc.targetPrefix}";

      installPhase = ''
        mkdir -p ${installDir}
        cp ${lib.concatStringsSep " " filesToInstall} ${installDir}
      '';

      meta = with lib; {
        homepage = "https://www.hardkernel.com/";
        description = "Das U-Boot from Hardkernel with Odroid embedded devices firmware and support";
        license = licenses.unfreeRedistributableFirmware;
        maintainers = with maintainers; [ aarapov ];
      } // extraMeta;
    } // removeAttrs args [ "extraMeta" ]);
in {
  inherit buildHardkernelFirmware;

  # https://wiki.odroid.com/odroid-c2/software/building_u-boot
  firmwareOdroidC2 = let
    name = "odroidc2";
    odroidc2-bl301 = fetchgit {
      url = "https://github.com/hardkernel/u-boot_firmware.git";
      rev = "b7b90c1099b057d35ebae886b7846b5d9bfb4143"; # "odroidc2-bl301"
      sha256 = "0kdb1mg5zd7qyabfpbh98cs07icfzpkywvva13ybf4mf5g50g0n3";
      deepClone = true;
    };
  in buildHardkernelFirmware {
    defconfig = "odroidc2_config";
    name = "firmware-odroid-c2";
    version = "2015.01";
    src = fetchgit {
      url = "https://github.com/hardkernel/u-boot.git";
      rev = "fac4d2da0a1b61dfdeaca0034a45151ff5983fb8"; # "odroidc2-v2015.01"
      sha256 = "0jrpd7vww659nazyrv5af6n165akhz0h9hnxajq7gz906igc5raz";
      leaveDotGit = true;
    };

    prePatch = ''
      git remote add u-boot_firmware ${odroidc2-bl301}/
      git fetch u-boot_firmware
      git cherry-pick --no-commit \
        5ce504067bb83de03d17173d5585e849df5d5a33^..${odroidc2-bl301.rev}

      substituteInPlace ./arch/arm/cpu/armv8/gxb/firmware/scp_task/Makefile \
        --replace "CROSS_COMPILE" "CROSS_COMPILE_32"
    '';

    filesToInstall = [
      "build/scp_task/bl301.bin" "fip/gxb/bl30.bin" "fip/gxb/bl2.package"
      "sd_fuse/sd_fusing.sh" "sd_fuse/bl1.bin.hardkernel"
    ];

    extraMeta.platforms = [ "aarch64-linux" ];
  };

  # https://wiki.odroid.com/odroid-c4/software/building_u-boot
  firmwareOdroidC4 = buildHardkernelFirmware {
    name = "firmware-odroid-c4";
    defconfig = "odroidc4_defconfig";
    version = "2015.01";
    src = fetchgit {
      url = "https://github.com/hardkernel/u-boot.git";
      rev = "90ebb7015c1bfbbf120b2b94273977f558a5da46"; # "odroidg12-v2015.01"
      sha256 = "1v8z5m0k6a9iw0qbkn6qcwh02rsdsfax29l2ilshr39a3nj40i96";
      leaveDotGit = true;
    };

    prePatch = ''
      substituteInPlace ./arch/arm/cpu/armv8/g12a/firmware/scp_task/Makefile \
        --replace "CROSS_COMPILE" "CROSS_COMPILE_32"
    '';

    filesToInstall = [
      "build/board/hardkernel/odroidc4/firmware/acs.bin" "build/scp_task/bl301.bin"
      "fip/g12a/bl2.bin" "fip/g12a/bl30.bin" "fip/g12a/bl31.img"
      "fip/g12a/ddr3_1d.fw" "fip/g12a/ddr4_1d.fw" "fip/g12a/ddr4_2d.fw"
      "fip/g12a/lpddr3_1d.fw" "fip/g12a/lpddr4_1d.fw" "fip/g12a/lpddr4_2d.fw"
      "fip/g12a/diag_lpddr4.fw" "fip/g12a/piei.fw" "fip/g12a/aml_ddr.fw"
      "fip/g12a/aml_encrypt_g12a" "sd_fuse/sd_fusing.sh"
    ];

    # Even though Odroid C4 firmware blobs are buildable on aarch64, we can not
    # use it to produce U-Boot loader binary on aarch64 machines. This is
    # because we do not have "aml_encrypt_g12a" binary compiled for aarch64.
    # So that "x86_64-linux" makes more sense here, though we have to keep
    # "aarch64-linux" in order to make this derivative consumable by ubootOdroidC4
    # derivative.
    extraMeta.platforms = [ "aarch64-linux" "x86_64-linux" ];
  };
}
