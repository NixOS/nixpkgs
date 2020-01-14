{ stdenv, lib, fetchurl, fetchpatch, fetchFromGitHub, bc, bison, dtc, flex
, openssl, swig, meson-tools, armTrustedFirmwareAllwinner
, armTrustedFirmwareRK3328, armTrustedFirmwareRK3399
, armTrustedFirmwareS905
, buildPackages
}:

let
  defaultVersion = "2019.10";
  defaultSrc = fetchurl {
    url = "ftp://ftp.denx.de/pub/u-boot/u-boot-${defaultVersion}.tar.bz2";
    sha256 = "053hcrwwlacqh2niisn0zas95zkbffw5aw5sdhixs8lmfdq60vcd";
  };
  buildUBoot = {
    version ? null
  , src ? null
  , filesToInstall
  , installDir ? "$out"
  , defconfig
  , extraConfig ? ""
  , extraPatches ? []
  , extraMakeFlags ? []
  , extraMeta ? {}
  , ... } @ args: stdenv.mkDerivation ({
    pname = "uboot-${defconfig}";

    version = if src == null then defaultVersion else version;

    src = if src == null then defaultSrc else src;

    patches = [
      # Submitted upstream: https://patchwork.ozlabs.org/patch/1203693/
      (fetchpatch {
        url = https://github.com/dezgeg/u-boot/commit/extlinux-path-length-2018-03.patch;
        sha256 = "07jafdnxvqv8lz256qy29agjc2k1zj5ad4k28r1w5qkhwj4ixmf8";
      })
      # Submitted upstream: https://patchwork.ozlabs.org/patch/1203678/
      (fetchpatch {
        name = "rockchip-allow-loading-larger-kernels.patch";
        url = "https://marc.info/?l=u-boot&m=157537843004298&q=raw";
        sha256 = "0l3l88cc9xkxkraql82pfgpx6nqn4dj7cvfaagh5pzfwkxyw0n3p";
      })
    ] ++ extraPatches;

    postPatch = ''
      patchShebangs tools
      patchShebangs arch/arm/mach-rockchip
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
      maintainers = with maintainers; [ dezgeg samueldr lopsided98 ];
    } // extraMeta;
  } // removeAttrs args [ "extraMeta" ]);

in {
  inherit buildUBoot;

  ubootTools = buildUBoot {
    defconfig = "tools-only_defconfig";
    installDir = "$out/bin";
    hardeningDisable = [];
    dontStrip = false;
    extraMeta.platforms = lib.platforms.linux;
    extraMakeFlags = [ "HOST_TOOLS_ALL=y" "CROSS_BUILD_TOOLS=1" "NO_SDL=1" "tools" ];
    filesToInstall = [
      "tools/dumpimage"
      "tools/fdtgrep"
      "tools/kwboot"
      "tools/mkenvimage"
      "tools/mkimage"
    ];
  };

  ubootA20OlinuxinoLime = buildUBoot {
    defconfig = "A20-OLinuXino-Lime_defconfig";
    extraMeta.platforms = ["armv7l-linux"];
    filesToInstall = ["u-boot-sunxi-with-spl.bin"];
  };

  ubootBananaPi = buildUBoot {
    defconfig = "Bananapi_defconfig";
    extraMeta.platforms = ["armv7l-linux"];
    filesToInstall = ["u-boot-sunxi-with-spl.bin"];
  };

  ubootBananaPim3 = buildUBoot {
    defconfig = "Sinovoip_BPI_M3_defconfig";
    extraMeta.platforms = ["armv7l-linux"];
    filesToInstall = ["u-boot-sunxi-with-spl.bin"];
  };

  ubootBananaPim64 = buildUBoot {
    defconfig = "bananapi_m64_defconfig";
    extraMeta.platforms = ["aarch64-linux"];
    BL31 = "${armTrustedFirmwareAllwinner}/bl31.bin";
    filesToInstall = ["u-boot-sunxi-with-spl.bin"];
  };

  ubootBeagleboneBlack = buildUBoot {
    defconfig = "am335x_boneblack_defconfig";
    extraMeta.platforms = ["armv7l-linux"];
    filesToInstall = ["MLO" "u-boot.img"];
  };

  # http://git.denx.de/?p=u-boot.git;a=blob;f=board/solidrun/clearfog/README;hb=refs/heads/master
  ubootClearfog = buildUBoot {
    defconfig = "clearfog_defconfig";
    extraMeta.platforms = ["armv7l-linux"];
    filesToInstall = ["u-boot-spl.kwb"];
  };

  ubootGuruplug = buildUBoot {
    defconfig = "guruplug_defconfig";
    extraMeta.platforms = ["armv5tel-linux"];
    filesToInstall = ["u-boot.bin"];
  };

  ubootJetsonTK1 = buildUBoot {
    defconfig = "jetson-tk1_defconfig";
    extraMeta.platforms = ["armv7l-linux"];
    filesToInstall = ["u-boot" "u-boot.dtb" "u-boot-dtb-tegra.bin" "u-boot-nodtb-tegra.bin"];
    # tegra-uboot-flasher expects this exact directory layout, sigh...
    postInstall = ''
      mkdir -p $out/spl
      cp spl/u-boot-spl $out/spl/
    '';
  };

  ubootNovena = buildUBoot {
    defconfig = "novena_defconfig";
    extraMeta.platforms = ["armv7l-linux"];
    filesToInstall = ["u-boot.bin" "SPL"];
  };

  # Flashing instructions:
  # dd if=bl1.bin.hardkernel of=<device> conv=fsync bs=1 count=442
  # dd if=bl1.bin.hardkernel of=<device> conv=fsync bs=512 skip=1 seek=1
  # dd if=u-boot.gxbb of=<device> conv=fsync bs=512 seek=97
  ubootOdroidC2 = let
    firmwareBlobs = fetchFromGitHub {
      owner = "armbian";
      repo = "odroidc2-blobs";
      rev = "47c5aac4bcac6f067cebe76e41fb9924d45b429c";
      sha256 = "1ns0a130yxnxysia8c3q2fgyjp9k0nkr689dxk88qh2vnibgchnp";
      meta.license = lib.licenses.unfreeRedistributableFirmware;
    };
  in buildUBoot {
    defconfig = "odroid-c2_defconfig";
    extraMeta.platforms = ["aarch64-linux"];
    filesToInstall = ["u-boot.bin" "u-boot.gxbb" "${firmwareBlobs}/bl1.bin.hardkernel"];
    postBuild = ''
      # BL301 image needs at least 64 bytes of padding after it to place
      # signing headers (with amlbootsig)
      truncate -s 64 bl301.padding.bin
      cat '${firmwareBlobs}/gxb/bl301.bin' bl301.padding.bin > bl301.padded.bin
      # The downstream fip_create tool adds a custom TOC entry with UUID
      # AABBCCDD-ABCD-EFEF-ABCD-12345678ABCD for the BL301 image. It turns out
      # that the firmware blob does not actually care about UUIDs, only the
      # order the images appear in the file. Because fiptool does not know
      # about the BL301 UUID, we would have to use the --blob option, which adds
      # the image to the end of the file, causing the boot to fail. Instead, we
      # take advantage of the fact that UUIDs are ignored and just put the
      # images in the right order with the wrong UUIDs. In the command below,
      # --tb-fw is really --scp-fw and --scp-fw is the BL301 image.
      #
      # See https://github.com/afaerber/meson-tools/issues/3 for more
      # information.
      '${buildPackages.armTrustedFirmwareTools}/bin/fiptool' create \
        --align 0x4000 \
        --tb-fw '${firmwareBlobs}/gxb/bl30.bin' \
        --scp-fw bl301.padded.bin \
        --soc-fw '${armTrustedFirmwareS905}/bl31.bin' \
        --nt-fw u-boot.bin \
        fip.bin
      cat '${firmwareBlobs}/gxb/bl2.package' fip.bin > boot_new.bin
      '${buildPackages.meson-tools}/bin/amlbootsig' boot_new.bin u-boot.img
      dd if=u-boot.img of=u-boot.gxbb bs=512 skip=96
    '';
  };

  ubootOdroidXU3 = buildUBoot {
    defconfig = "odroid-xu3_defconfig";
    extraMeta.platforms = ["armv7l-linux"];
    filesToInstall = ["u-boot-dtb.bin"];
  };

  ubootOrangePiPc = buildUBoot {
    defconfig = "orangepi_pc_defconfig";
    extraMeta.platforms = ["armv7l-linux"];
    filesToInstall = ["u-boot-sunxi-with-spl.bin"];
  };

  ubootOrangePiZeroPlus2H5 = buildUBoot {
    defconfig = "orangepi_zero_plus2_defconfig";
    extraMeta.platforms = ["aarch64-linux"];
    BL31 = "${armTrustedFirmwareAllwinner}/bl31.bin";
    filesToInstall = ["u-boot-sunxi-with-spl.bin"];
  };

  ubootPcduino3Nano = buildUBoot {
    defconfig = "Linksprite_pcDuino3_Nano_defconfig";
    extraMeta.platforms = ["armv7l-linux"];
    filesToInstall = ["u-boot-sunxi-with-spl.bin"];
  };

  ubootPine64 = buildUBoot {
    defconfig = "pine64_plus_defconfig";
    extraMeta.platforms = ["aarch64-linux"];
    BL31 = "${armTrustedFirmwareAllwinner}/bl31.bin";
    filesToInstall = ["u-boot-sunxi-with-spl.bin"];
  };

  ubootPine64LTS = buildUBoot {
    defconfig = "pine64-lts_defconfig";
    extraMeta.platforms = ["aarch64-linux"];
    BL31 = "${armTrustedFirmwareAllwinner}/bl31.bin";
    filesToInstall = ["u-boot-sunxi-with-spl.bin"];
  };

  ubootPinebook = buildUBoot {
    defconfig = "pinebook_defconfig";
    extraMeta.platforms = ["aarch64-linux"];
    BL31 = "${armTrustedFirmwareAllwinner}/bl31.bin";
    filesToInstall = ["u-boot-sunxi-with-spl.bin"];
  };

  ubootQemuAarch64 = buildUBoot {
    defconfig = "qemu_arm64_defconfig";
    extraMeta.platforms = ["aarch64-linux"];
    filesToInstall = ["u-boot.bin"];
  };

  ubootQemuArm = buildUBoot {
    defconfig = "qemu_arm_defconfig";
    extraMeta.platforms = ["armv7l-linux"];
    filesToInstall = ["u-boot.bin"];
  };

  ubootRaspberryPi = buildUBoot {
    defconfig = "rpi_defconfig";
    extraMeta.platforms = ["armv6l-linux"];
    filesToInstall = ["u-boot.bin"];
  };

  ubootRaspberryPi2 = buildUBoot {
    defconfig = "rpi_2_defconfig";
    extraMeta.platforms = ["armv7l-linux"];
    filesToInstall = ["u-boot.bin"];
  };

  ubootRaspberryPi3_32bit = buildUBoot {
    defconfig = "rpi_3_32b_defconfig";
    extraMeta.platforms = ["armv7l-linux"];
    filesToInstall = ["u-boot.bin"];
  };

  ubootRaspberryPi3_64bit = buildUBoot {
    defconfig = "rpi_3_defconfig";
    extraMeta.platforms = ["aarch64-linux"];
    filesToInstall = ["u-boot.bin"];
  };

  ubootRaspberryPiZero = buildUBoot {
    defconfig = "rpi_0_w_defconfig";
    extraMeta.platforms = ["armv6l-linux"];
    filesToInstall = ["u-boot.bin"];
  };

  ubootRock64 = let
    rkbin = fetchFromGitHub {
      owner = "ayufan-rock64";
      repo = "rkbin";
      rev = "f79a708978232a2b6b06c2e4173c5314559e0d3a";
      sha256 = "0h7xm4ck3p3380c6bqm5ixrkxwcx6z5vysqdwvfa7gcqx5d6x5zz";
    };
  in buildUBoot {
    extraMakeFlags = [ "all" "u-boot.itb" ];
    defconfig = "rock64-rk3328_defconfig";
    extraMeta = {
      platforms = [ "aarch64-linux" ];
      license = lib.licenses.unfreeRedistributableFirmware;
    };
    BL31="${armTrustedFirmwareRK3328}/bl31.elf";
    filesToInstall = [ "u-boot.itb" "idbloader.img"];
    # Derive MAC address from cpuid
    # Submitted upstream: https://patchwork.ozlabs.org/patch/1203686/
    extraConfig = ''
      CONFIG_MISC_INIT_R=y
    '';
    # Close to being blob free, but the U-Boot TPL causes random memory
    # corruption
    postBuild = ''
      ./tools/mkimage -n rk3328 -T rksd -d ${rkbin}/rk33/rk3328_ddr_786MHz_v1.13.bin idbloader.img
      cat spl/u-boot-spl.bin >> idbloader.img
    '';
  };

  ubootRockPro64 = buildUBoot {
    extraMakeFlags = [ "all" "u-boot.itb" ];
    defconfig = "rockpro64-rk3399_defconfig";
    extraMeta.platforms = ["aarch64-linux"];
    BL31="${armTrustedFirmwareRK3399}/bl31.elf";
    filesToInstall = [ "u-boot.itb" "idbloader.img"];
  };

  ubootSheevaplug = buildUBoot {
    defconfig = "sheevaplug_defconfig";
    extraMeta.platforms = ["armv5tel-linux"];
    filesToInstall = ["u-boot.kwb"];
  };

  ubootSopine = buildUBoot {
    defconfig = "sopine_baseboard_defconfig";
    extraMeta.platforms = ["aarch64-linux"];
    BL31 = "${armTrustedFirmwareAllwinner}/bl31.bin";
    filesToInstall = ["u-boot-sunxi-with-spl.bin"];
  };

  ubootUtilite = buildUBoot {
    defconfig = "cm_fx6_defconfig";
    extraMeta.platforms = ["armv7l-linux"];
    filesToInstall = ["u-boot-with-nand-spl.imx"];
    buildFlags = [ "u-boot-with-nand-spl.imx" ];
    extraConfig = ''
      CONFIG_CMD_SETEXPR=y
    '';
    # sata init; load sata 0 $loadaddr u-boot-with-nand-spl.imx
    # sf probe; sf update $loadaddr 0 80000
  };

  ubootWandboard = buildUBoot {
    defconfig = "wandboard_defconfig";
    extraMeta.platforms = ["armv7l-linux"];
    filesToInstall = ["u-boot.img" "SPL"];
  };
}
