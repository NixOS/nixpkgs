{
  stdenv,
  lib,
  bc,
  bison,
  dtc,
  fetchFromGitHub,
  fetchpatch,
  fetchurl,
  flex,
  gnutls,
  installShellFiles,
  libuuid,
  meson-tools,
  ncurses,
  openssl,
  rkbin,
  swig,
  which,
  python3,
  perl,
  armTrustedFirmwareAllwinner,
  armTrustedFirmwareAllwinnerH6,
  armTrustedFirmwareAllwinnerH616,
  armTrustedFirmwareRK3328,
  armTrustedFirmwareRK3399,
  armTrustedFirmwareRK3568,
  armTrustedFirmwareRK3588,
  armTrustedFirmwareS905,
  opensbi,
  buildPackages,
  callPackages,
  darwin,
}@pkgs:

let
  defaultVersion = "2025.07";
  defaultSrc = fetchurl {
    url = "https://ftp.denx.de/pub/u-boot/u-boot-${defaultVersion}.tar.bz2";
    hash = "sha256-D5M/bFpCaJW/MG6T5qxTxghw5LVM2lbZUhG+yZ5jvsc=";
  };

  # Dependencies for the tools need to be included as either native or cross,
  # depending on which we're building
  toolsDeps = [
    ncurses # tools/kwboot
    libuuid # tools/mkeficapsule
    gnutls # tools/mkeficapsule
    openssl # tools/mkimage and tools/env/fw_printenv
  ];

  buildUBoot = lib.makeOverridable (
    {
      version ? null,
      src ? null,
      filesToInstall,
      pythonScriptsToInstall ? { },
      installDir ? "$out",
      defconfig,
      extraConfig ? "",
      descriptionEnd ? "embedded systems",
      extraPatches ? [ ],
      extraMakeFlags ? [ ],
      extraMeta ? { },
      crossTools ? false,
      stdenv ? pkgs.stdenv,
      ...
    }@args:
    stdenv.mkDerivation (
      {
        pname = "uboot-${defconfig}";

        version = if src == null then defaultVersion else version;

        src = if src == null then defaultSrc else src;

        patches = extraPatches;

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
          perl # for oid build (secureboot)
        ]
        ++ lib.optionals (!crossTools) toolsDeps
        ++ lib.optionals stdenv.buildPlatform.isDarwin [ darwin.DarwinTools ]; # sw_vers command is needed on darwin
        depsBuildBuild = [ buildPackages.gccStdenv.cc ]; # gccStdenv is needed for Darwin buildPlatform
        buildInputs = lib.optionals crossTools toolsDeps;

        hardeningDisable = [ "all" ];

        enableParallelBuilding = true;

        makeFlags = [
          "DTC=${lib.getExe buildPackages.dtc}"
          "CROSS_COMPILE=${stdenv.cc.targetPrefix}"
          "HOSTCFLAGS=-fcommon"
        ]
        ++ extraMakeFlags;

        passAsFile = [ "extraConfig" ];

        configurePhase = ''
          runHook preConfigure

          make -j$NIX_BUILD_CORES ${defconfig}

          cat $extraConfigPath >> .config

          runHook postConfigure
        '';

        installPhase = ''
          runHook preInstall

          mkdir -p ${installDir}
          cp ${
            lib.concatStringsSep " " (filesToInstall ++ builtins.attrNames pythonScriptsToInstall)
          } ${installDir}

          mkdir -p "$out/nix-support"
          ${lib.concatMapStrings (file: ''
            echo "file binary-dist ${installDir}/${baseNameOf file}" >> "$out/nix-support/hydra-build-products"
          '') (filesToInstall ++ builtins.attrNames pythonScriptsToInstall)}

          runHook postInstall
        '';

        dontStrip = true;

        meta =
          with lib;
          {
            homepage = "https://www.denx.de/wiki/U-Boot/";
            description = "Boot loader (U-Boot) for ${descriptionEnd}";
            license = licenses.gpl2Plus;
            maintainers = with maintainers; [
              dezgeg
              lopsided98
            ];
          }
          // extraMeta;
      }
      // removeAttrs args [
        "descriptionEnd"
        "extraMeta"
        "pythonScriptsToInstall"
      ]
    )
  );
in
{
  inherit buildUBoot;

  ubootTools = buildUBoot {
    defconfig = "tools-only_defconfig";
    installDir = "$out/bin";
    hardeningDisable = [ ];
    dontStrip = false;
    extraMeta = {
      description = "Tools for working with U-Boot";
      platforms = lib.platforms.linux;
    };

    crossTools = true;
    extraMakeFlags = [
      "HOST_TOOLS_ALL=y"
      "NO_SDL=1"
      "cross_tools"
      "envtools"
    ];

    outputs = [
      "out"
      "man"
    ];

    postInstall = ''
      installManPage doc/*.1

      # from u-boot's tools/env/README:
      # "You should then create a symlink from fw_setenv to fw_printenv. They
      # use the same program and its function depends on its basename."
      ln -s $out/bin/fw_printenv $out/bin/fw_setenv
    '';

    filesToInstall = [
      "tools/dumpimage"
      "tools/fdt_add_pubkey"
      "tools/fdtgrep"
      "tools/kwboot"
      "tools/mkeficapsule"
      "tools/mkenvimage"
      "tools/mkimage"
      "tools/env/fw_printenv"
      "tools/mkeficapsule"
    ];

    pythonScriptsToInstall = {
      "tools/efivar.py" = (python3.withPackages (ps: [ ps.pyopenssl ]));
    };
  };

  ubootPythonTools = lib.recurseIntoAttrs (callPackages ./python.nix { });

  ubootA20OlinuxinoLime = buildUBoot {
    descriptionEnd = "the A20-OLinuXino-LIME from Olimex";
    defconfig = "A20-OLinuXino-Lime_defconfig";
    extraMeta.platforms = [ "armv7l-linux" ];
    filesToInstall = [ "u-boot-sunxi-with-spl.bin" ];
  };

  ubootA20OlinuxinoLime2EMMC = buildUBoot {
    descriptionEnd = "the A20-OLinuXino-LIME2-eMMC from Olimex";
    defconfig = "A20-OLinuXino-Lime2-eMMC_defconfig";
    extraMeta.platforms = [ "armv7l-linux" ];
    filesToInstall = [ "u-boot-sunxi-with-spl.bin" ];
  };

  ubootAmx335xEVM = buildUBoot {
    descriptionEnd = "the AM335x Evaluation Module (EVM) from Texas Instruments";
    defconfig = "am335x_evm_defconfig";
    extraMeta = {
      platforms = [ "armv7l-linux" ];
      broken = true; # too big, exceeds memory size
    };
    filesToInstall = [
      "MLO"
      "u-boot.img"
    ];
  };

  ubootBananaPi = buildUBoot {
    descriptionEnd = "the Banana Pi";
    defconfig = "Bananapi_defconfig";
    extraMeta.platforms = [ "armv7l-linux" ];
    filesToInstall = [ "u-boot-sunxi-with-spl.bin" ];
  };

  ubootBananaPim2Zero = buildUBoot {
    descriptionEnd = "the Banana Pi M2 Zero";
    defconfig = "bananapi_m2_zero_defconfig";
    filesToInstall = [ "u-boot-sunxi-with-spl.bin" ];
    extraMeta.platforms = [ "armv7l-linux" ];
  };

  ubootBananaPim3 = buildUBoot {
    descriptionEnd = "the Banana Pi M3";
    defconfig = "Sinovoip_BPI_M3_defconfig";
    extraMeta.platforms = [ "armv7l-linux" ];
    filesToInstall = [ "u-boot-sunxi-with-spl.bin" ];
  };

  ubootBananaPim64 = buildUBoot {
    descriptionEnd = "the Banana Pi M64";
    defconfig = "bananapi_m64_defconfig";
    extraMeta.platforms = [ "aarch64-linux" ];
    BL31 = "${armTrustedFirmwareAllwinner}/bl31.bin";
    SCP = "/dev/null";
    filesToInstall = [ "u-boot-sunxi-with-spl.bin" ];
  };

  # http://git.denx.de/?p=u-boot.git;a=blob;f=board/solidrun/clearfog/README;hb=refs/heads/master
  ubootClearfog = buildUBoot {
    descriptionEnd = "the ClearFog Base and Pro from SolidRun";
    defconfig = "clearfog_defconfig";
    extraMeta.platforms = [ "armv7l-linux" ];
    filesToInstall = [ "u-boot-with-spl.kwb" ];
  };

  ubootCM3588NAS = buildUBoot {
    descriptionEnd = "the CM3588 NAS Kit from FriendlyElec";
    defconfig = "cm3588-nas-rk3588_defconfig";
    extraMeta.platforms = [ "aarch64-linux" ];
    BL31 = "${armTrustedFirmwareRK3588}/bl31.elf";
    ROCKCHIP_TPL = rkbin.TPL_RK3588;
    filesToInstall = [
      "u-boot.itb"
      "idbloader.img"
      "u-boot-rockchip.bin"
    ];
  };

  ubootCubieboard2 = buildUBoot {
    descriptionEnd = "the Cubieboard2 from CubieTech";
    defconfig = "Cubieboard2_defconfig";
    extraMeta.platforms = [ "armv7l-linux" ];
    filesToInstall = [ "u-boot-sunxi-with-spl.bin" ];
  };

  ubootGuruplug = buildUBoot {
    descriptionEnd = "the GuruPlug from Globalscale";
    defconfig = "guruplug_defconfig";
    extraMeta.platforms = [ "armv5tel-linux" ];
    filesToInstall = [ "u-boot.bin" ];
  };

  ubootJetsonTK1 = buildUBoot {
    descriptionEnd = "the Nvidia Jetson TK1";
    defconfig = "jetson-tk1_defconfig";
    extraMeta.platforms = [ "armv7l-linux" ];
    filesToInstall = [
      "u-boot"
      "u-boot.dtb"
      "u-boot-dtb-tegra.bin"
      "u-boot-nodtb-tegra.bin"
    ];
    # tegra-uboot-flasher expects this exact directory layout, sigh...
    postInstall = ''
      mkdir -p $out/spl
      cp spl/u-boot-spl $out/spl/
    '';
  };

  # Flashing instructions:
  # dd if=u-boot.gxl.sd.bin of=<sdcard> conv=fsync,notrunc bs=512 skip=1 seek=1
  # dd if=u-boot.gxl.sd.bin of=<sdcard> conv=fsync,notrunc bs=1 count=444
  ubootLibreTechCC =
    let
      firmwareImagePkg = fetchFromGitHub {
        owner = "LibreELEC";
        repo = "amlogic-boot-fip";
        rev = "4369a138ca24c5ab932b8cbd1af4504570b709df";
        sha256 = "sha256-mGRUwdh3nW4gBwWIYHJGjzkezHxABwcwk/1gVRis7Tc=";
        meta.license = lib.licenses.unfreeRedistributableFirmware;
      };
    in
    buildUBoot {
      descriptionEnd = "the LibreTech CC ‘LePotato’ from the Libre Computer Project";
      defconfig = "libretech-cc_defconfig";
      extraMeta = {
        broken = stdenv.buildPlatform.system != "x86_64-linux"; # aml_encrypt_gxl is a x86_64 binary
        platforms = [ "aarch64-linux" ];
      };
      filesToInstall = [ "u-boot.bin" ];
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
    descriptionEnd = "the NanoPC-T4 from FriendlyElec";

    rkbin = fetchFromGitHub {
      owner = "armbian";
      repo = "rkbin";
      rev = "3bd0321cae5ef881a6005fb470009ad5a5d1462d";
      sha256 = "09r4dzxsbs3pff4sh70qnyp30s3rc7pkc46v1m3152s7jqjasp31";
    };

    defconfig = "nanopc-t4-rk3399_defconfig";

    extraMeta = {
      platforms = [ "aarch64-linux" ];
      license = lib.licenses.unfreeRedistributableFirmware;
    };
    BL31 = "${armTrustedFirmwareRK3399}/bl31.elf";
    filesToInstall = [
      "u-boot.itb"
      "idbloader.img"
    ];
    postBuild = ''
      ./tools/mkimage -n rk3399 -T rksd -d ${rkbin}/rk33/rk3399_ddr_800MHz_v1.24.bin idbloader.img
      cat ${rkbin}/rk33/rk3399_miniloader_v1.19.bin >> idbloader.img
    '';
  };

  ubootNanoPCT6 = buildUBoot {
    descriptionEnd = "the NanoPC-T6 from FriendlyElec";
    defconfig = "nanopc-t6-rk3588_defconfig";
    extraMeta.platforms = [ "aarch64-linux" ];
    BL31 = "${armTrustedFirmwareRK3588}/bl31.elf";
    ROCKCHIP_TPL = rkbin.TPL_RK3588;
    filesToInstall = [
      "u-boot.itb"
      "idbloader.img"
      "u-boot-rockchip.bin"
      "u-boot-rockchip-spi.bin"
    ];
  };

  ubootNovena = buildUBoot {
    descriptionEnd = "the Novena from Kosagi";
    defconfig = "novena_defconfig";
    extraMeta.platforms = [ "armv7l-linux" ];
    filesToInstall = [
      "u-boot-dtb.img"
      "SPL"
    ];
  };

  # Flashing instructions:
  # dd if=bl1.bin.hardkernel of=<device> conv=fsync bs=1 count=442
  # dd if=bl1.bin.hardkernel of=<device> conv=fsync bs=512 skip=1 seek=1
  # dd if=u-boot.gxbb of=<device> conv=fsync bs=512 seek=97
  ubootOdroidC2 =
    let
      firmwareBlobs = fetchFromGitHub {
        owner = "armbian";
        repo = "odroidc2-blobs";
        rev = "47c5aac4bcac6f067cebe76e41fb9924d45b429c";
        sha256 = "1ns0a130yxnxysia8c3q2fgyjp9k0nkr689dxk88qh2vnibgchnp";
        meta.license = lib.licenses.unfreeRedistributableFirmware;
      };
    in
    buildUBoot {
      descriptionEnd = "the ODROID-C2 from Hardkernel";
      defconfig = "odroid-c2_defconfig";
      extraMeta.platforms = [ "aarch64-linux" ];
      filesToInstall = [
        "u-boot.bin"
        "u-boot.gxbb"
        "${firmwareBlobs}/bl1.bin.hardkernel"
      ];
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
    descriptionEnd = "the ODROID-XU3/XU4/HC1/HC2 from Hardkernel";
    defconfig = "odroid-xu3_defconfig";
    extraMeta.platforms = [ "armv7l-linux" ];
    filesToInstall = [ "u-boot-dtb.bin" ];
  };

  ubootOlimexA64Olinuxino = buildUBoot {
    descriptionEnd = "the A64-OLinuXino from Olimex";
    defconfig = "a64-olinuxino-emmc_defconfig";
    extraMeta.platforms = [ "aarch64-linux" ];
    BL31 = "${armTrustedFirmwareAllwinner}/bl31.bin";
    SCP = "/dev/null";
    filesToInstall = [ "u-boot-sunxi-with-spl.bin" ];
  };

  ubootOlimexA64Teres1 = buildUBoot {
    descriptionEnd = "the TERES-I from Olimex";
    defconfig = "teres_i_defconfig";
    extraMeta.platforms = [ "aarch64-linux" ];
    BL31 = "${armTrustedFirmwareAllwinner}/bl31.bin";
    # Using /dev/null here is upstream-specified way that disables the inclusion of crust-firmware as it's not yet packaged and without which the build will fail -- https://docs.u-boot.org/en/latest/board/allwinner/sunxi.html#building-the-crust-management-processor-firmware
    SCP = "/dev/null";
    filesToInstall = [ "u-boot-sunxi-with-spl.bin" ];
  };

  ubootOrangePi5 = buildUBoot {
    descriptionEnd = "the Orange Pi 5";
    defconfig = "orangepi-5-rk3588s_defconfig";
    extraMeta.platforms = [ "aarch64-linux" ];
    BL31 = "${armTrustedFirmwareRK3588}/bl31.elf";
    ROCKCHIP_TPL = rkbin.TPL_RK3588;
    filesToInstall = [
      "u-boot.itb"
      "idbloader.img"
      "u-boot-rockchip.bin"
      "u-boot-rockchip-spi.bin"
    ];
  };

  ubootOrangePi5Max = buildUBoot {
    descriptionEnd = " the Orange Pi 5 Max";
    defconfig = "orangepi-5-max-rk3588_defconfig";
    extraMeta.platforms = [ "aarch64-linux" ];
    BL31 = "${armTrustedFirmwareRK3588}/bl31.elf";
    ROCKCHIP_TPL = rkbin.TPL_RK3588;
    filesToInstall = [
      "u-boot.itb"
      "idbloader.img"
      "u-boot-rockchip.bin"
      "u-boot-rockchip-spi.bin"
    ];
  };

  ubootOrangePi5Plus = buildUBoot {
    descriptionEnd = "the Orange Pi 5 Plus";
    defconfig = "orangepi-5-plus-rk3588_defconfig";
    extraMeta.platforms = [ "aarch64-linux" ];
    BL31 = "${armTrustedFirmwareRK3588}/bl31.elf";
    ROCKCHIP_TPL = rkbin.TPL_RK3588;
    filesToInstall = [
      "u-boot.itb"
      "idbloader.img"
      "u-boot-rockchip.bin"
      "u-boot-rockchip-spi.bin"
    ];
  };

  ubootOrangePiPc = buildUBoot {
    descriptionEnd = "the Orange Pi PC";
    defconfig = "orangepi_pc_defconfig";
    extraMeta.platforms = [ "armv7l-linux" ];
    filesToInstall = [ "u-boot-sunxi-with-spl.bin" ];
  };

  ubootOrangePiZeroPlus2H5 = buildUBoot {
    descriptionEnd = "the Orange Pi Zero Plus2";
    defconfig = "orangepi_zero_plus2_defconfig";
    extraMeta.platforms = [ "aarch64-linux" ];
    BL31 = "${armTrustedFirmwareAllwinner}/bl31.bin";
    SCP = "/dev/null";
    filesToInstall = [ "u-boot-sunxi-with-spl.bin" ];
  };

  ubootOrangePiZero = buildUBoot {
    descriptionEnd = "the Orange Pi Zero";
    defconfig = "orangepi_zero_defconfig";
    extraMeta.platforms = [ "armv7l-linux" ];
    filesToInstall = [ "u-boot-sunxi-with-spl.bin" ];
  };

  ubootOrangePiZero2 = buildUBoot {
    descriptionEnd = "the Orange Pi Zero2";
    defconfig = "orangepi_zero2_defconfig";
    extraMeta.platforms = [ "aarch64-linux" ];
    BL31 = "${armTrustedFirmwareAllwinnerH616}/bl31.bin";
    filesToInstall = [ "u-boot-sunxi-with-spl.bin" ];
  };

  ubootOrangePiZero3 = buildUBoot {
    descriptionEnd = "the Orange Pi Zero3";
    defconfig = "orangepi_zero3_defconfig";
    extraMeta.platforms = [ "aarch64-linux" ];
    # According to https://linux-sunxi.org/H616 the H618 "is a minor update with a larger (1MB) L2 cache" (compared to the H616)
    # but "does require extra support in U-Boot, TF-A and sunxi-fel. Support for that has been merged in mainline releases."
    # But no extra support seems to be in TF-A.
    BL31 = "${armTrustedFirmwareAllwinnerH616}/bl31.bin";
    filesToInstall = [ "u-boot-sunxi-with-spl.bin" ];
  };

  ubootOrangePi3 = buildUBoot {
    descriptionEnd = "the Orange Pi 3";
    defconfig = "orangepi_3_defconfig";
    extraMeta.platforms = [ "aarch64-linux" ];
    BL31 = "${armTrustedFirmwareAllwinnerH6}/bl31.bin";
    SCP = "/dev/null";
    filesToInstall = [ "u-boot-sunxi-with-spl.bin" ];
  };

  ubootOrangePi3B = buildUBoot {
    descriptionEnd = "the Orange Pi 3B";
    defconfig = "orangepi-3b-rk3566_defconfig";
    extraMeta.platforms = [ "aarch64-linux" ];
    ROCKCHIP_TPL = rkbin.TPL_RK3568;
    BL31 = rkbin.BL31_RK3568;
    filesToInstall = [
      "u-boot.itb"
      "idbloader.img"
      "u-boot-rockchip.bin"
      "u-boot-rockchip-spi.bin"
    ];
  };

  ubootPcduino3Nano = buildUBoot {
    descriptionEnd = "the LinkSprite pcDuino3 Nano";
    defconfig = "Linksprite_pcDuino3_Nano_defconfig";
    extraMeta.platforms = [ "armv7l-linux" ];
    filesToInstall = [ "u-boot-sunxi-with-spl.bin" ];
  };

  ubootPine64 = buildUBoot {
    descriptionEnd = "the PINE A64 and PINE A64+ by Pine64";
    defconfig = "pine64_plus_defconfig";
    extraMeta.platforms = [ "aarch64-linux" ];
    BL31 = "${armTrustedFirmwareAllwinner}/bl31.bin";
    SCP = "/dev/null";
    filesToInstall = [ "u-boot-sunxi-with-spl.bin" ];
  };

  ubootPine64LTS = buildUBoot {
    descriptionEnd = "the PINE A64-LTS by Pine64";
    defconfig = "pine64-lts_defconfig";
    extraMeta.platforms = [ "aarch64-linux" ];
    BL31 = "${armTrustedFirmwareAllwinner}/bl31.bin";
    SCP = "/dev/null";
    filesToInstall = [ "u-boot-sunxi-with-spl.bin" ];
  };

  ubootPinebook = buildUBoot {
    descriptionEnd = "the Pinebook by Pine64";
    defconfig = "pinebook_defconfig";
    extraMeta.platforms = [ "aarch64-linux" ];
    BL31 = "${armTrustedFirmwareAllwinner}/bl31.bin";
    SCP = "/dev/null";
    filesToInstall = [ "u-boot-sunxi-with-spl.bin" ];
  };

  ubootPinebookPro = buildUBoot {
    descriptionEnd = "the Pinebook Pro by Pine64";
    defconfig = "pinebook-pro-rk3399_defconfig";
    extraMeta.platforms = [ "aarch64-linux" ];
    BL31 = "${armTrustedFirmwareRK3399}/bl31.elf";
    filesToInstall = [
      "u-boot.itb"
      "idbloader.img"
    ];
  };

  ubootQemuAarch64 = buildUBoot {
    descriptionEnd = "QEMU ARM64";
    defconfig = "qemu_arm64_defconfig";
    extraMeta.platforms = [ "aarch64-linux" ];
    filesToInstall = [ "u-boot.bin" ];
  };

  ubootQemuArm = buildUBoot {
    descriptionEnd = "QEMU ARM (32-bit)";
    defconfig = "qemu_arm_defconfig";
    extraMeta.platforms = [ "armv7l-linux" ];
    filesToInstall = [ "u-boot.bin" ];
  };

  ubootQemuRiscv64Smode = buildUBoot {
    descriptionEnd = "QEMU RISC-V 64-bit S-Mode";
    defconfig = "qemu-riscv64_smode_defconfig";
    extraMeta.platforms = [ "riscv64-linux" ];
    filesToInstall = [ "u-boot.bin" ];
  };

  ubootQemuX86 = buildUBoot {
    descriptionEnd = "QEMU x86 (32-bit)";
    defconfig = "qemu-x86_defconfig";
    extraConfig = ''
      CONFIG_USB_UHCI_HCD=y
      CONFIG_USB_EHCI_HCD=y
      CONFIG_USB_EHCI_GENERIC=y
      CONFIG_USB_XHCI_HCD=y
    '';
    extraMeta.platforms = [
      "i686-linux"
      "x86_64-linux"
    ];
    filesToInstall = [ "u-boot.rom" ];
  };

  ubootQemuX86_64 = buildUBoot {
    descriptionEnd = "QEMU x86 (64-bit)";
    defconfig = "qemu-x86_64_defconfig";
    extraConfig = ''
      CONFIG_USB_UHCI_HCD=y
      CONFIG_USB_EHCI_HCD=y
      CONFIG_USB_EHCI_GENERIC=y
      CONFIG_USB_XHCI_HCD=y
    '';
    extraMeta.platforms = [ "x86_64-linux" ];
    filesToInstall = [ "u-boot.rom" ];
  };

  ubootQuartz64B = buildUBoot {
    descriptionEnd = "the Quartz64 Model B by Pine64";
    defconfig = "quartz64-b-rk3566_defconfig";
    extraMeta.platforms = [ "aarch64-linux" ];
    BL31 = "${armTrustedFirmwareRK3568}/bl31.elf";
    ROCKCHIP_TPL = rkbin.TPL_RK3566;
    filesToInstall = [
      "idbloader.img"
      "idbloader-spi.img"
      "u-boot.itb"
      "u-boot-rockchip.bin"
      "u-boot-rockchip-spi.bin"
    ];
  };

  ubootRadxaZero3W = buildUBoot {
    descriptionEnd = "the Radxa ZERO 3W";
    defconfig = "radxa-zero-3-rk3566_defconfig";
    extraMeta.platforms = [ "aarch64-linux" ];
    BL31 = "${armTrustedFirmwareRK3568}/bl31.elf";
    ROCKCHIP_TPL = rkbin.TPL_RK3566;
    filesToInstall = [
      "idbloader.img"
      "u-boot.itb"
      "u-boot-rockchip.bin"
    ];
  };

  ubootRaspberryPi = buildUBoot {
    descriptionEnd = "the Raspberry Pi (all BCM2835 variants)";
    defconfig = "rpi_defconfig";
    extraMeta.platforms = [ "armv6l-linux" ];
    filesToInstall = [ "u-boot.bin" ];
  };

  ubootRaspberryPi2 = buildUBoot {
    descriptionEnd = "the Raspberry Pi 2";
    defconfig = "rpi_2_defconfig";
    extraMeta.platforms = [ "armv7l-linux" ];
    filesToInstall = [ "u-boot.bin" ];
  };

  ubootRaspberryPi3_32bit = buildUBoot {
    descriptionEnd = "the Raspberry Pi 3 (32-bit build)";
    defconfig = "rpi_3_32b_defconfig";
    extraMeta.platforms = [ "armv7l-linux" ];
    filesToInstall = [ "u-boot.bin" ];
  };

  ubootRaspberryPi3_64bit = buildUBoot {
    descriptionEnd = "the Raspberry Pi 3 (64-bit build)";
    defconfig = "rpi_3_defconfig";
    extraMeta.platforms = [ "aarch64-linux" ];
    filesToInstall = [ "u-boot.bin" ];
  };

  ubootRaspberryPi4_32bit = buildUBoot {
    descriptionEnd = "the Raspberry Pi 4 (32-bit build)";
    defconfig = "rpi_4_32b_defconfig";
    extraMeta.platforms = [ "armv7l-linux" ];
    filesToInstall = [ "u-boot.bin" ];
  };

  ubootRaspberryPi4_64bit = buildUBoot {
    descriptionEnd = "the Raspberry Pi 4 (64-bit build)";
    defconfig = "rpi_4_defconfig";
    extraMeta.platforms = [ "aarch64-linux" ];
    filesToInstall = [ "u-boot.bin" ];
  };

  ubootRaspberryPiZero = buildUBoot {
    descriptionEnd = "the Raspberry Pi Zero and Zero W";
    defconfig = "rpi_0_w_defconfig";
    extraMeta.platforms = [ "armv6l-linux" ];
    filesToInstall = [ "u-boot.bin" ];
  };

  ubootRock4CPlus = buildUBoot {
    descriptionEnd = "the Radxa ROCK 4C+";
    defconfig = "rock-4c-plus-rk3399_defconfig";
    extraMeta.platforms = [ "aarch64-linux" ];
    BL31 = "${armTrustedFirmwareRK3399}/bl31.elf";
    filesToInstall = [
      "u-boot.itb"
      "idbloader.img"
    ];
  };

  ubootRock5ModelB = buildUBoot {
    descriptionEnd = "the Radxa ROCK 5B";
    defconfig = "rock5b-rk3588_defconfig";
    extraMeta.platforms = [ "aarch64-linux" ];
    BL31 = "${armTrustedFirmwareRK3588}/bl31.elf";
    ROCKCHIP_TPL = rkbin.TPL_RK3588;
    filesToInstall = [
      "u-boot.itb"
      "idbloader.img"
      "u-boot-rockchip.bin"
      "u-boot-rockchip-spi.bin"
    ];
  };

  ubootRock64 = buildUBoot {
    descriptionEnd = "the ROCK64 by Pine64";
    defconfig = "rock64-rk3328_defconfig";
    extraMeta.platforms = [ "aarch64-linux" ];
    BL31 = "${armTrustedFirmwareRK3328}/bl31.elf";
    filesToInstall = [
      "u-boot.itb"
      "idbloader.img"
      "u-boot-rockchip.bin"
    ];
  };

  # A special build with much lower memory frequency (666 vs 1600 MT/s) which
  # makes ROCK64 V2 boards stable. This is necessary because the DDR3 routing
  # on that revision is marginal and not unconditionally stable at the specified
  # frequency. If your ROCK64 is unstable you can try this u-boot variant to
  # see if it works better for you. The only disadvantage is lowered memory
  # bandwidth.
  ubootRock64v2 = buildUBoot {
    descriptionEnd = "the ROCK64 V2 by Pine64";
    prePatch = ''
      substituteInPlace arch/arm/dts/rk3328-rock64-u-boot.dtsi \
        --replace rk3328-sdram-lpddr3-1600.dtsi rk3328-sdram-lpddr3-666.dtsi
    '';
    defconfig = "rock64-rk3328_defconfig";
    extraMeta.platforms = [ "aarch64-linux" ];
    BL31 = "${armTrustedFirmwareRK3328}/bl31.elf";
    filesToInstall = [
      "u-boot.itb"
      "idbloader.img"
      "u-boot-rockchip.bin"
    ];
  };

  ubootRockPiE = buildUBoot {
    descriptionEnd = "the Radxa ROCK Pi E";
    defconfig = "rock-pi-e-rk3328_defconfig";
    extraMeta.platforms = [ "aarch64-linux" ];
    BL31 = "${armTrustedFirmwareRK3328}/bl31.elf";
    filesToInstall = [
      "u-boot.itb"
      "idbloader.img"
      "u-boot-rockchip.bin"
    ];
  };

  ubootRockPro64 = buildUBoot {
    descriptionEnd = "the ROCKPro64 by Pine64";
    defconfig = "rockpro64-rk3399_defconfig";
    extraMeta.platforms = [ "aarch64-linux" ];
    BL31 = "${armTrustedFirmwareRK3399}/bl31.elf";
    filesToInstall = [
      "u-boot.itb"
      "idbloader.img"
    ];
  };

  ubootROCPCRK3399 = buildUBoot {
    descriptionEnd = "the ROC-RK3399-PC from Firefly";
    defconfig = "roc-pc-rk3399_defconfig";
    extraMeta.platforms = [ "aarch64-linux" ];
    filesToInstall = [
      "spl/u-boot-spl.bin"
      "u-boot.itb"
      "idbloader.img"
    ];
    BL31 = "${armTrustedFirmwareRK3399}/bl31.elf";
  };

  ubootSheevaplug = buildUBoot {
    descriptionEnd = "the Sheevaplug from Globalscale";
    defconfig = "sheevaplug_defconfig";
    extraMeta = {
      platforms = [ "armv5tel-linux" ];
      broken = true; # too big, exceeds partition size
    };
    filesToInstall = [ "u-boot.kwb" ];
  };

  ubootSopine = buildUBoot {
    descriptionEnd = "the SOPINE by Pine64";
    defconfig = "sopine_baseboard_defconfig";
    extraMeta.platforms = [ "aarch64-linux" ];
    BL31 = "${armTrustedFirmwareAllwinner}/bl31.bin";
    SCP = "/dev/null";
    filesToInstall = [ "u-boot-sunxi-with-spl.bin" ];
  };

  ubootTuringRK1 = buildUBoot {
    descriptionEnd = "the Turing RK1";
    defconfig = "turing-rk1-rk3588_defconfig";
    extraMeta.platforms = [ "aarch64-linux" ];
    BL31 = "${armTrustedFirmwareRK3588}/bl31.elf";
    ROCKCHIP_TPL = rkbin.TPL_RK3588;
    filesToInstall = [
      "u-boot.itb"
      "idbloader.img"
      "u-boot-rockchip.bin"
    ];
  };

  ubootUtilite = buildUBoot {
    descriptionEnd = "the CompuLab Utilite";
    defconfig = "cm_fx6_defconfig";
    extraMeta.platforms = [ "armv7l-linux" ];
    filesToInstall = [ "u-boot-with-nand-spl.imx" ];
    buildFlags = [ "u-boot-with-nand-spl.imx" ];
    extraConfig = ''
      CONFIG_CMD_SETEXPR=y
    '';
    # sata init; load sata 0 $loadaddr u-boot-with-nand-spl.imx
    # sf probe; sf update $loadaddr 0 80000
  };

  ubootVisionFive2 = buildUBoot {
    descriptionEnd = "the StarFive VisionFive 2";
    defconfig = "starfive_visionfive2_defconfig";
    extraMeta.platforms = [ "riscv64-linux" ];
    OPENSBI = "${opensbi}/share/opensbi/lp64/generic/firmware/fw_dynamic.bin";
    filesToInstall = [
      "spl/u-boot-spl.bin.normal.out"
      "u-boot.itb"
    ];
  };

  ubootWandboard = buildUBoot {
    descriptionEnd = "the Wandboard";
    defconfig = "wandboard_defconfig";
    extraMeta.platforms = [ "armv7l-linux" ];
    filesToInstall = [
      "u-boot.img"
      "SPL"
    ];
  };

  ubootRockPi4 = buildUBoot {
    descriptionEnd = "the Radxa Rock Pi 4";
    defconfig = "rock-pi-4-rk3399_defconfig";
    extraMeta.platforms = [ "aarch64-linux" ];
    BL31 = "${armTrustedFirmwareRK3399}/bl31.elf";
    filesToInstall = [
      "u-boot.itb"
      "idbloader.img"
    ];
  };
}
