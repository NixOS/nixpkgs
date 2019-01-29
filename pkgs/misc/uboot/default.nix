{ stdenv, lib, fetchurl, fetchpatch, bc, bison, dtc, flex, openssl, swig
, armTrustedFirmwareAllwinner
, buildPackages
}:

let
  buildUBoot = { version ? "2018.09"
            , filesToInstall
            , installDir ? "$out"
            , defconfig
            , extraConfig ? ""
            , extraPatches ? []
            , extraMakeFlags ? []
            , extraMeta ? {}
            , ... } @ args:
           stdenv.mkDerivation (rec {

    pname = "uboot-${defconfig}";
    inherit version;

    src = fetchurl {
      url = "ftp://ftp.denx.de/pub/u-boot/u-boot-${version}.tar.bz2";
      sha256 = "0s122kyz1svvs2yjzj4j9qravl3ra4vn0fjqgski7rlczqyg56w3";
    };

    patches = [
      (fetchpatch {
        url = https://github.com/dezgeg/u-boot/commit/extlinux-path-length-2018-03.patch;
        sha256 = "07jafdnxvqv8lz256qy29agjc2k1zj5ad4k28r1w5qkhwj4ixmf8";
      })
    ] ++ extraPatches;

    postPatch = ''
      patchShebangs tools
    '';

    nativeBuildInputs = [
      bc
      bison
      dtc
      flex
      openssl
      (buildPackages.python2.withPackages (p: [ p.libfdt ]))
      swig
    ];
    depsBuildBuild = [ buildPackages.stdenv.cc ];

    hardeningDisable = [ "all" ];

    makeFlags = [
      "DTC=dtc"
      "CROSS_COMPILE=${stdenv.cc.targetPrefix}"
    ] ++ extraMakeFlags;

    passAsFile = [ "extraConfig" ];

    configurePhase = ''
      runHook preConfigure

      make ${defconfig}

      cat $extraConfigPath >> .config

      runHook postConfigure
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p ${installDir}
      cp ${lib.concatStringsSep " " filesToInstall} ${installDir}

      runHook postInstall
    '';

    # make[2]: *** No rule to make target 'lib/efi_loader/helloworld.efi', needed by '__build'.  Stop.
    enableParallelBuilding = false;

    dontStrip = true;

    meta = with lib; {
      homepage = http://www.denx.de/wiki/U-Boot/;
      description = "Boot loader for embedded systems";
      license = licenses.gpl2;
      maintainers = [ maintainers.dezgeg ];
    } // extraMeta;
  } // removeAttrs args [ "extraMeta" ]);

in rec {
  inherit buildUBoot;

  ubootTools = buildUBoot rec {
    defconfig = "allnoconfig";
    installDir = "$out/bin";
    hardeningDisable = [];
    dontStrip = false;
    extraMeta.platforms = lib.platforms.linux;
    extraMakeFlags = [ "HOST_TOOLS_ALL=y" "CROSS_BUILD_TOOLS=1" "NO_SDL=1" "tools" ];
    postConfigure = ''
      sed -i '/CONFIG_SYS_TEXT_BASE/c\CONFIG_SYS_TEXT_BASE=0x00000000' .config
    '';
    filesToInstall = [
      "tools/dumpimage"
      "tools/fdtgrep"
      "tools/kwboot"
      "tools/mkenvimage"
      "tools/mkimage"
    ];
  };

  ubootA20OlinuxinoLime = buildUBoot rec {
    defconfig = "A20-OLinuXino-Lime_defconfig";
    extraMeta.platforms = ["armv7l-linux"];
    filesToInstall = ["u-boot-sunxi-with-spl.bin"];
  };

  ubootBananaPi = buildUBoot rec {
    defconfig = "Bananapi_defconfig";
    extraMeta.platforms = ["armv7l-linux"];
    filesToInstall = ["u-boot-sunxi-with-spl.bin"];
  };

  ubootBeagleboneBlack = buildUBoot rec {
    defconfig = "am335x_boneblack_defconfig";
    extraMeta.platforms = ["armv7l-linux"];
    filesToInstall = ["MLO" "u-boot.img"];
  };

  # http://git.denx.de/?p=u-boot.git;a=blob;f=board/solidrun/clearfog/README;hb=refs/heads/master
  ubootClearfog = buildUBoot rec {
    defconfig = "clearfog_defconfig";
    extraMeta.platforms = ["armv7l-linux"];
    filesToInstall = ["u-boot-spl.kwb"];
  };

  ubootGuruplug = buildUBoot rec {
    defconfig = "guruplug_defconfig";
    extraMeta.platforms = ["armv5tel-linux"];
    filesToInstall = ["u-boot.bin"];
  };

  ubootJetsonTK1 = buildUBoot rec {
    defconfig = "jetson-tk1_defconfig";
    extraMeta.platforms = ["armv7l-linux"];
    filesToInstall = ["u-boot" "u-boot.dtb" "u-boot-dtb-tegra.bin" "u-boot-nodtb-tegra.bin"];
    # tegra-uboot-flasher expects this exact directory layout, sigh...
    postInstall = ''
      mkdir -p $out/spl
      cp spl/u-boot-spl $out/spl/
    '';
  };

  ubootNovena = buildUBoot rec {
    defconfig = "novena_defconfig";
    extraMeta.platforms = ["armv7l-linux"];
    filesToInstall = ["u-boot.bin" "SPL"];
  };

  ubootOdroidXU3 = buildUBoot rec {
    defconfig = "odroid-xu3_defconfig";
    extraMeta.platforms = ["armv7l-linux"];
    filesToInstall = ["u-boot-dtb.bin"];
  };

  ubootOrangePiPc = buildUBoot rec {
    defconfig = "orangepi_pc_defconfig";
    extraMeta.platforms = ["armv7l-linux"];
    filesToInstall = ["u-boot-sunxi-with-spl.bin"];
  };

  ubootOrangePiZeroPlus2H5 = buildUBoot rec {
    defconfig = "orangepi_zero_plus2_defconfig";
    extraMeta.platforms = ["aarch64-linux"];
    BL31 = "${armTrustedFirmwareAllwinner}/bl31.bin";
    filesToInstall = ["u-boot-sunxi-with-spl.bin"];
  };

  ubootPcduino3Nano = buildUBoot rec {
    defconfig = "Linksprite_pcDuino3_Nano_defconfig";
    extraMeta.platforms = ["armv7l-linux"];
    filesToInstall = ["u-boot-sunxi-with-spl.bin"];
  };

  ubootPine64 = buildUBoot rec {
    defconfig = "pine64_plus_defconfig";
    extraMeta.platforms = ["aarch64-linux"];
    BL31 = "${armTrustedFirmwareAllwinner}/bl31.bin";
    filesToInstall = ["u-boot-sunxi-with-spl.bin"];
  };

  ubootQemuAarch64 = buildUBoot rec {
    defconfig = "qemu_arm64_defconfig";
    extraMeta.platforms = ["aarch64-linux"];
    filesToInstall = ["u-boot.bin"];
  };

  ubootQemuArm = buildUBoot rec {
    defconfig = "qemu_arm_defconfig";
    extraMeta.platforms = ["armv7l-linux"];
    filesToInstall = ["u-boot.bin"];
  };

  ubootRaspberryPi = buildUBoot rec {
    defconfig = "rpi_defconfig";
    extraMeta.platforms = ["armv6l-linux"];
    filesToInstall = ["u-boot.bin"];
  };

  ubootRaspberryPi2 = buildUBoot rec {
    defconfig = "rpi_2_defconfig";
    extraMeta.platforms = ["armv7l-linux"];
    filesToInstall = ["u-boot.bin"];
  };

  ubootRaspberryPi3_32bit = buildUBoot rec {
    defconfig = "rpi_3_32b_defconfig";
    extraMeta.platforms = ["armv7l-linux"];
    filesToInstall = ["u-boot.bin"];
  };

  ubootRaspberryPi3_64bit = buildUBoot rec {
    defconfig = "rpi_3_defconfig";
    extraMeta.platforms = ["aarch64-linux"];
    filesToInstall = ["u-boot.bin"];
  };

  ubootRaspberryPiZero = buildUBoot rec {
    defconfig = "rpi_0_w_defconfig";
    extraMeta.platforms = ["armv6l-linux"];
    filesToInstall = ["u-boot.bin"];
  };

  ubootSheevaplug = buildUBoot rec {
    defconfig = "sheevaplug_defconfig";
    extraMeta.platforms = ["armv5tel-linux"];
    filesToInstall = ["u-boot.bin"];
  };

  ubootSopine = buildUBoot rec {
    defconfig = "sopine_baseboard_defconfig";
    extraMeta.platforms = ["aarch64-linux"];
    BL31 = "${armTrustedFirmwareAllwinner}/bl31.bin";
    filesToInstall = ["u-boot-sunxi-with-spl.bin"];
  };

  ubootUtilite = buildUBoot rec {
    defconfig = "cm_fx6_defconfig";
    extraMeta.platforms = ["armv7l-linux"];
    filesToInstall = ["u-boot-with-nand-spl.imx"];
    buildFlags = "u-boot-with-nand-spl.imx";
    extraConfig = ''
      CONFIG_CMD_SETEXPR=y
    '';
    # sata init; load sata 0 $loadaddr u-boot-with-nand-spl.imx
    # sf probe; sf update $loadaddr 0 80000
  };

  ubootWandboard = buildUBoot rec {
    defconfig = "wandboard_defconfig";
    extraMeta.platforms = ["armv7l-linux"];
    filesToInstall = ["u-boot.img" "SPL"];
  };
}
