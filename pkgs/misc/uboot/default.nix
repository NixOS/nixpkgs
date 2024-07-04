{ stdenv
, lib
, bc
, bison
, dtc
, fetchFromGitHub
, fetchpatch
, fetchurl
, flex
, gnutls
, installShellFiles
, libuuid
, meson-tools
, ncurses
, openssl
, rkbin
, swig
, which
, python3
, armTrustedFirmwareAllwinner
, armTrustedFirmwareAllwinnerH6
, armTrustedFirmwareAllwinnerH616
, armTrustedFirmwareRK3328
, armTrustedFirmwareRK3399
, armTrustedFirmwareRK3588
, armTrustedFirmwareS905
, buildPackages
}:

let
  defaultVersion = "2024.04";
  defaultSrc = fetchurl {
    url = "https://ftp.denx.de/pub/u-boot/u-boot-${defaultVersion}.tar.bz2";
    hash = "sha256-GKhT/jn6160DqQzC1Cda6u1tppc13vrDSSuAUIhD3Uo=";
  };

  # Dependencies for the tools need to be included as either native or cross,
  # depending on which we're building
  toolsDeps = [
    ncurses # tools/kwboot
    libuuid # tools/mkeficapsule
    gnutls # tools/mkeficapsule
    openssl # tools/mkimage
  ];

  buildUBoot = lib.makeOverridable ({
    version ? null
  , src ? null
  , filesToInstall
  , pythonScriptsToInstall ? { }
  , installDir ? "$out"
  , defconfig
  , extraConfig ? ""
  , extraPatches ? []
  , extraMakeFlags ? []
  , extraMeta ? {}
  , crossTools ? false
  , ... } @ args: stdenv.mkDerivation ({
    pname = "uboot-${defconfig}";

    version = if src == null then defaultVersion else version;

    src = if src == null then defaultSrc else src;

    patches = [
      ./0001-configs-rpi-allow-for-bigger-kernels.patch
    ] ++ extraPatches;

    postPatch = ''
      ${lib.concatMapStrings (script: ''
        substituteInPlace ${script} \
        --replace "#!/usr/bin/env python3" "#!${pythonScriptsToInstall.${script}}/bin/python3"
      '') (builtins.attrNames pythonScriptsToInstall)}
      patchShebangs tools
      patchShebangs scripts
    '';

    nativeBuildInputs = [
      ncurses # tools/kwboot
      bc
      bison
      flex
      installShellFiles
      (buildPackages.python3.withPackages (p: [
        p.libfdt
        p.setuptools # for pkg_resources
        p.pyelftools
      ]))
      swig
      which # for scripts/dtc-version.sh
    ] ++ lib.optionals (!crossTools) toolsDeps;
    depsBuildBuild = [ buildPackages.stdenv.cc ];
    buildInputs = lib.optionals crossTools toolsDeps;

    hardeningDisable = [ "all" ];

    enableParallelBuilding = true;

    makeFlags = [
      "DTC=${lib.getExe buildPackages.dtc}"
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
      cp ${lib.concatStringsSep " " (filesToInstall ++ builtins.attrNames pythonScriptsToInstall)} ${installDir}

      mkdir -p "$out/nix-support"
      ${lib.concatMapStrings (file: ''
        echo "file binary-dist ${installDir}/${builtins.baseNameOf file}" >> "$out/nix-support/hydra-build-products"
      '') (filesToInstall ++ builtins.attrNames pythonScriptsToInstall)}

      runHook postInstall
    '';

    dontStrip = true;

    meta = with lib; {
      homepage = "https://www.denx.de/wiki/U-Boot/";
      description = "Boot loader for embedded systems";
      license = licenses.gpl2;
      maintainers = with maintainers; [ bartsch dezgeg lopsided98 ];
    } // extraMeta;
  } // removeAttrs args [ "extraMeta" "pythonScriptsToInstall" ]));
in {
  inherit buildUBoot;

  ubootTools = buildUBoot {
    defconfig = "tools-only_defconfig";
    installDir = "$out/bin";
    hardeningDisable = [];
    dontStrip = false;
    extraMeta.platforms = lib.platforms.linux;

    crossTools = true;
    extraMakeFlags = [ "HOST_TOOLS_ALL=y" "NO_SDL=1" "cross_tools" ];

    outputs = [ "out" "man" ];

    postInstall = ''
      installManPage doc/*.1
    '';
    filesToInstall = [
      "tools/dumpimage"
      "tools/fdtgrep"
      "tools/kwboot"
      "tools/mkenvimage"
      "tools/mkimage"
    ];

    pythonScriptsToInstall = {
      "tools/efivar.py" = (python3.withPackages (ps: [ ps.pyopenssl ]));
    };
  };

  ubootA20OlinuxinoLime = buildUBoot {
    defconfig = "A20-OLinuXino-Lime_defconfig";
    extraMeta.platforms = ["armv7l-linux"];
    filesToInstall = ["u-boot-sunxi-with-spl.bin"];
  };

  ubootA20OlinuxinoLime2EMMC = buildUBoot {
    defconfig = "A20-OLinuXino-Lime2-eMMC_defconfig";
    extraMeta.platforms = ["armv7l-linux"];
    filesToInstall = ["u-boot-sunxi-with-spl.bin"];
  };

  ubootAmx335xEVM = buildUBoot {
    defconfig = "am335x_evm_defconfig";
    extraMeta.platforms = ["armv7l-linux"];
    filesToInstall = ["MLO" "u-boot.img"];
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
    SCP = "/dev/null";
    filesToInstall = ["u-boot-sunxi-with-spl.bin"];
  };

  # http://git.denx.de/?p=u-boot.git;a=blob;f=board/solidrun/clearfog/README;hb=refs/heads/master
  ubootClearfog = buildUBoot {
    defconfig = "clearfog_defconfig";
    extraMeta.platforms = ["armv7l-linux"];
    filesToInstall = ["u-boot-with-spl.kwb"];
  };

  ubootCubieboard2 = buildUBoot {
    defconfig = "Cubieboard2_defconfig";
    extraMeta.platforms = ["armv7l-linux"];
    filesToInstall = ["u-boot-sunxi-with-spl.bin"];
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

  # Flashing instructions:
  # dd if=u-boot.gxl.sd.bin of=<sdcard> conv=fsync,notrunc bs=512 skip=1 seek=1
  # dd if=u-boot.gxl.sd.bin of=<sdcard> conv=fsync,notrunc bs=1 count=444
  ubootLibreTechCC = let
    firmwareImagePkg = fetchFromGitHub {
      owner = "LibreELEC";
      repo = "amlogic-boot-fip";
      rev = "4369a138ca24c5ab932b8cbd1af4504570b709df";
      sha256 = "sha256-mGRUwdh3nW4gBwWIYHJGjzkezHxABwcwk/1gVRis7Tc=";
      meta.license = lib.licenses.unfreeRedistributableFirmware;
    };
  in
  assert stdenv.buildPlatform.system == "x86_64-linux"; # aml_encrypt_gxl is a x86_64 binary
  buildUBoot {
    defconfig = "libretech-cc_defconfig";
    extraMeta.platforms = ["aarch64-linux"];
    filesToInstall = ["u-boot.bin"];
    postBuild = ''
      # Copy binary files & tools from LibreELEC/amlogic-boot-fip, and u-boot build to working dir
      mkdir $out tmp
      cp ${firmwareImagePkg}/lepotato/{acs.bin,bl2.bin,bl21.bin,bl30.bin,bl301.bin,bl31.img} \
         ${firmwareImagePkg}/lepotato/{acs_tool.py,aml_encrypt_gxl,blx_fix.sh} \
         u-boot.bin tmp/
      cd tmp
      python3 acs_tool.py bl2.bin bl2_acs.bin acs.bin 0

      bash -e blx_fix.sh bl2_acs.bin zero bl2_zero.bin bl21.bin bl21_zero.bin bl2_new.bin bl2
      [ -f zero ] && rm zero

      bash -e blx_fix.sh bl30.bin zero bl30_zero.bin bl301.bin bl301_zero.bin bl30_new.bin bl30
      [ -f zero ] && rm zero

      ./aml_encrypt_gxl --bl2sig --input bl2_new.bin --output bl2.n.bin.sig
      ./aml_encrypt_gxl --bl3enc --input bl30_new.bin --output bl30_new.bin.enc
      ./aml_encrypt_gxl --bl3enc --input bl31.img --output bl31.img.enc
      ./aml_encrypt_gxl --bl3enc --input u-boot.bin --output bl33.bin.enc
      ./aml_encrypt_gxl --bootmk --output $out/u-boot.gxl \
        --bl2 bl2.n.bin.sig --bl30 bl30_new.bin.enc --bl31 bl31.img.enc --bl33 bl33.bin.enc
    '';
  };

  ubootNanoPCT4 = buildUBoot rec {
    rkbin = fetchFromGitHub {
      owner = "armbian";
      repo = "rkbin";
      rev = "3bd0321cae5ef881a6005fb470009ad5a5d1462d";
      sha256 = "09r4dzxsbs3pff4sh70qnyp30s3rc7pkc46v1m3152s7jqjasp31";
    };

    defconfig = "nanopc-t4-rk3399_defconfig";

    extraMeta = {
      platforms = ["aarch64-linux"];
      license = lib.licenses.unfreeRedistributableFirmware;
    };
    BL31="${armTrustedFirmwareRK3399}/bl31.elf";
    filesToInstall = ["u-boot.itb" "idbloader.img"];
    postBuild = ''
      ./tools/mkimage -n rk3399 -T rksd -d ${rkbin}/rk33/rk3399_ddr_800MHz_v1.24.bin idbloader.img
      cat ${rkbin}/rk33/rk3399_miniloader_v1.19.bin >> idbloader.img
    '';
  };

  ubootNanoPCT6 = buildUBoot {
    defconfig = "nanopc-t6-rk3588_defconfig";
    extraMeta.platforms = ["aarch64-linux"];
    BL31 = "${armTrustedFirmwareRK3588}/bl31.elf";
    ROCKCHIP_TPL = rkbin.TPL_RK3588;
    filesToInstall = [ "u-boot.itb" "idbloader.img" "u-boot-rockchip.bin" ];
  };

  ubootNovena = buildUBoot {
    defconfig = "novena_defconfig";
    extraMeta.platforms = ["armv7l-linux"];
    filesToInstall = ["u-boot-dtb.img" "SPL"];
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

  ubootOlimexA64Olinuxino = buildUBoot {
    defconfig = "a64-olinuxino-emmc_defconfig";
    extraMeta.platforms = ["aarch64-linux"];
    BL31 = "${armTrustedFirmwareAllwinner}/bl31.bin";
    SCP = "/dev/null";
    filesToInstall = ["u-boot-sunxi-with-spl.bin"];
  };

  ubootOlimexA64Teres1 = buildUBoot {
    defconfig = "teres_i_defconfig";
    extraMeta.platforms = ["aarch64-linux"];
    BL31 = "${armTrustedFirmwareAllwinner}/bl31.bin";
    # Using /dev/null here is upstream-specified way that disables the inclusion of crust-firmware as it's not yet packaged and without which the build will fail -- https://docs.u-boot.org/en/latest/board/allwinner/sunxi.html#building-the-crust-management-processor-firmware
    SCP = "/dev/null";
    filesToInstall = ["u-boot-sunxi-with-spl.bin"];
  };

  ubootOrangePi5 = buildUBoot {
    defconfig = "orangepi-5-rk3588s_defconfig";
    extraMeta.platforms = ["aarch64-linux"];
    BL31 = "${armTrustedFirmwareRK3588}/bl31.elf";
    ROCKCHIP_TPL = rkbin.TPL_RK3588;
    filesToInstall = [ "u-boot.itb" "idbloader.img" "u-boot-rockchip.bin" "u-boot-rockchip-spi.bin" ];
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
    SCP = "/dev/null";
    filesToInstall = ["u-boot-sunxi-with-spl.bin"];
  };

  ubootOrangePiZero = buildUBoot {
    defconfig = "orangepi_zero_defconfig";
    extraMeta.platforms = ["armv7l-linux"];
    filesToInstall = ["u-boot-sunxi-with-spl.bin"];
  };

  ubootOrangePiZero2 = buildUBoot {
    defconfig = "orangepi_zero2_defconfig";
    extraMeta.platforms = ["aarch64-linux"];
    BL31 = "${armTrustedFirmwareAllwinnerH616}/bl31.bin";
    filesToInstall = ["u-boot-sunxi-with-spl.bin"];
  };

  ubootOrangePi3 = buildUBoot {
    defconfig = "orangepi_3_defconfig";
    extraMeta.platforms = ["aarch64-linux"];
    BL31 = "${armTrustedFirmwareAllwinnerH6}/bl31.bin";
    SCP = "/dev/null";
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
    SCP = "/dev/null";
    filesToInstall = ["u-boot-sunxi-with-spl.bin"];
  };

  ubootPine64LTS = buildUBoot {
    defconfig = "pine64-lts_defconfig";
    extraMeta.platforms = ["aarch64-linux"];
    BL31 = "${armTrustedFirmwareAllwinner}/bl31.bin";
    SCP = "/dev/null";
    filesToInstall = ["u-boot-sunxi-with-spl.bin"];
  };

  ubootPinebook = buildUBoot {
    defconfig = "pinebook_defconfig";
    extraMeta.platforms = ["aarch64-linux"];
    BL31 = "${armTrustedFirmwareAllwinner}/bl31.bin";
    SCP = "/dev/null";
    filesToInstall = ["u-boot-sunxi-with-spl.bin"];
  };

  ubootPinebookPro = buildUBoot {
    defconfig = "pinebook-pro-rk3399_defconfig";
    extraMeta.platforms = ["aarch64-linux"];
    BL31 = "${armTrustedFirmwareRK3399}/bl31.elf";
    filesToInstall = [ "u-boot.itb" "idbloader.img"];
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

  ubootQemuRiscv64Smode = buildUBoot {
    defconfig = "qemu-riscv64_smode_defconfig";
    extraMeta.platforms = ["riscv64-linux"];
    filesToInstall = ["u-boot.bin"];
  };

  ubootQemuX86 = buildUBoot {
    defconfig = "qemu-x86_defconfig";
    extraConfig = ''
      CONFIG_USB_UHCI_HCD=y
      CONFIG_USB_EHCI_HCD=y
      CONFIG_USB_EHCI_GENERIC=y
      CONFIG_USB_XHCI_HCD=y
    '';
    extraMeta.platforms = [ "i686-linux" "x86_64-linux" ];
    filesToInstall = [ "u-boot.rom" ];
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

  ubootRaspberryPi4_32bit = buildUBoot {
    defconfig = "rpi_4_32b_defconfig";
    extraMeta.platforms = ["armv7l-linux"];
    filesToInstall = ["u-boot.bin"];
  };

  ubootRaspberryPi4_64bit = buildUBoot {
    defconfig = "rpi_4_defconfig";
    extraMeta.platforms = ["aarch64-linux"];
    filesToInstall = ["u-boot.bin"];
  };

  ubootRaspberryPiZero = buildUBoot {
    defconfig = "rpi_0_w_defconfig";
    extraMeta.platforms = ["armv6l-linux"];
    filesToInstall = ["u-boot.bin"];
  };

  ubootRock4CPlus = buildUBoot {
    defconfig = "rock-4c-plus-rk3399_defconfig";
    extraMeta.platforms = [ "aarch64-linux" ];
    BL31 = "${armTrustedFirmwareRK3399}/bl31.elf";
    filesToInstall = [ "u-boot.itb" "idbloader.img" ];
  };

  ubootRock5ModelB = buildUBoot {
    defconfig = "rock5b-rk3588_defconfig";
    extraMeta.platforms = ["aarch64-linux"];
    BL31 = "${armTrustedFirmwareRK3588}/bl31.elf";
    ROCKCHIP_TPL = rkbin.TPL_RK3588;
    filesToInstall = [ "u-boot.itb" "idbloader.img" "u-boot-rockchip.bin" "u-boot-rockchip-spi.bin" ];
  };

  ubootRock64 = buildUBoot {
    defconfig = "rock64-rk3328_defconfig";
    extraMeta.platforms = [ "aarch64-linux" ];
    BL31="${armTrustedFirmwareRK3328}/bl31.elf";
    filesToInstall = [ "u-boot.itb" "idbloader.img" "u-boot-rockchip.bin" ];
  };

  # A special build with much lower memory frequency (666 vs 1600 MT/s) which
  # makes ROCK64 V2 boards stable. This is necessary because the DDR3 routing
  # on that revision is marginal and not uncoditionally stable at the specified
  # frequency. If your ROCK64 is unstable you can try this u-boot variant to
  # see if it works better for you. The only disadvantage is lowered memory
  # bandwidth.
  ubootRock64v2 = buildUBoot {
    prePatch = ''
      substituteInPlace arch/arm/dts/rk3328-rock64-u-boot.dtsi \
        --replace rk3328-sdram-lpddr3-1600.dtsi rk3328-sdram-lpddr3-666.dtsi
    '';
    defconfig = "rock64-rk3328_defconfig";
    extraMeta.platforms = [ "aarch64-linux" ];
    BL31="${armTrustedFirmwareRK3328}/bl31.elf";
    filesToInstall = [ "u-boot.itb" "idbloader.img" "u-boot-rockchip.bin" ];
  };

  ubootRockPro64 = buildUBoot {
    extraPatches = [
      # https://patchwork.ozlabs.org/project/uboot/list/?series=237654&archive=both&state=*
      (fetchpatch {
        url = "https://patchwork.ozlabs.org/series/237654/mbox/";
        sha256 = "0aiw9zk8w4msd3v8nndhkspjify0yq6a5f0zdy6mhzs0ilq896c3";
      })
    ];
    defconfig = "rockpro64-rk3399_defconfig";
    extraMeta.platforms = ["aarch64-linux"];
    BL31="${armTrustedFirmwareRK3399}/bl31.elf";
    filesToInstall = [ "u-boot.itb" "idbloader.img"];
  };

  ubootROCPCRK3399 = buildUBoot {
    defconfig = "roc-pc-rk3399_defconfig";
    extraMeta.platforms = ["aarch64-linux"];
    filesToInstall = [ "spl/u-boot-spl.bin" "u-boot.itb" "idbloader.img"];
    BL31 = "${armTrustedFirmwareRK3399}/bl31.elf";
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
    SCP = "/dev/null";
    filesToInstall = ["u-boot-sunxi-with-spl.bin"];
  };

  ubootTuringRK1 = buildUBoot {
    defconfig = "turing-rk1-rk3588_defconfig";
    extraMeta.platforms = [ "aarch64-linux" ];
    BL31 = "${armTrustedFirmwareRK3588}/bl31.elf";
    ROCKCHIP_TPL = rkbin.TPL_RK3588;
    filesToInstall = [ "u-boot.itb" "idbloader.img" "u-boot-rockchip.bin" ];
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

  ubootRockPi4 = buildUBoot {
    defconfig = "rock-pi-4-rk3399_defconfig";
    extraMeta.platforms = ["aarch64-linux"];
    BL31 = "${armTrustedFirmwareRK3399}/bl31.elf";
    filesToInstall = [ "u-boot.itb" "idbloader.img"];
  };
}
