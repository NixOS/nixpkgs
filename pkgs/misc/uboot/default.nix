{ stdenv, fetchurl, fetchpatch, bc, dtc, python2
, hostPlatform
}:

let
  buildUBoot = { targetPlatforms
            , filesToInstall
            , installDir ? "$out"
            , defconfig
            , extraMeta ? {}
            , ... } @ args:
           stdenv.mkDerivation (rec {

    name = "uboot-${defconfig}-${version}";
    version = "2017.11";

    src = fetchurl {
      url = "ftp://ftp.denx.de/pub/u-boot/u-boot-${version}.tar.bz2";
      sha256 = "01bcsah5imy6m3fbjwhqywxg0pfk5fl8ks9ylb7kv3zmrb9qy0ba";
    };

    patches = [
      (fetchpatch {
        url = https://github.com/dezgeg/u-boot/commit/rpi-2017-11-patch1.patch;
        sha256 = "067yq55vv1slv4xy346px7h329pi14abdn04chg6s1s6hmf6c1x9";
      })
      (fetchpatch {
        url = https://github.com/dezgeg/u-boot/commit/rpi-2017-11-patch2.patch;
        sha256 = "0bbw0q027xvzvdxxvpzjajg4rm30a8mb7z74b6ma9q0l7y7bi0c4";
      })
      (fetchpatch {
        url = https://github.com/dezgeg/u-boot/commit/pythonpath-2017-11.patch;
        sha256 = "162b2lglp307pzxsf9m7nnmzwxqd7xkwp5j85bm6bg1a38ngpl9v";
      })
    ];

    postPatch = ''
      patchShebangs tools
    '';

    nativeBuildInputs = [ bc dtc python2 ];

    hardeningDisable = [ "all" ];

    makeFlags = [ "DTC=dtc" ];

    configurePhase = ''
      make ${defconfig}
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p ${installDir}
      cp ${stdenv.lib.concatStringsSep " " filesToInstall} ${installDir}

      runHook postInstall
    '';

    enableParallelBuilding = true;
    dontStrip = true;

    crossAttrs = {
      makeFlags = [
        "ARCH=${hostPlatform.platform.kernelArch}"
        "CROSS_COMPILE=${stdenv.cc.targetPrefix}"
      ];
    };

    meta = with stdenv.lib; {
      homepage = http://www.denx.de/wiki/U-Boot/;
      description = "Boot loader for embedded systems";
      license = licenses.gpl2;
      maintainers = [ maintainers.dezgeg ];
      platforms = targetPlatforms;
    } // extraMeta;
  } // args);

in rec {
  inherit buildUBoot;

  ubootTools = buildUBoot rec {
    defconfig = "allnoconfig";
    installDir = "$out/bin";
    buildFlags = "tools NO_SDL=1";
    dontStrip = false;
    targetPlatforms = stdenv.lib.platforms.linux;
    filesToInstall = ["tools/dumpimage" "tools/mkenvimage" "tools/mkimage"];
  };

  ubootA20OlinuxinoLime = buildUBoot rec {
    defconfig = "A20-OLinuXino-Lime_defconfig";
    targetPlatforms = ["armv7l-linux"];
    filesToInstall = ["u-boot-sunxi-with-spl.bin"];
  };

  ubootBananaPi = buildUBoot rec {
    defconfig = "Bananapi_defconfig";
    targetPlatforms = ["armv7l-linux"];
    filesToInstall = ["u-boot-sunxi-with-spl.bin"];
  };

  ubootBeagleboneBlack = buildUBoot rec {
    defconfig = "am335x_boneblack_defconfig";
    targetPlatforms = ["armv7l-linux"];
    filesToInstall = ["MLO" "u-boot.img"];
  };

  ubootJetsonTK1 = buildUBoot rec {
    defconfig = "jetson-tk1_defconfig";
    targetPlatforms = ["armv7l-linux"];
    filesToInstall = ["u-boot" "u-boot.dtb" "u-boot-dtb-tegra.bin" "u-boot-nodtb-tegra.bin"];
  };

  ubootOdroidXU3 = buildUBoot rec {
    defconfig = "odroid-xu3_defconfig";
    targetPlatforms = ["armv7l-linux"];
    filesToInstall = ["u-boot-dtb.bin"];
  };

  ubootPcduino3Nano = buildUBoot rec {
    defconfig = "Linksprite_pcDuino3_Nano_defconfig";
    targetPlatforms = ["armv7l-linux"];
    filesToInstall = ["u-boot-sunxi-with-spl.bin"];
  };

  ubootRaspberryPi = buildUBoot rec {
    defconfig = "rpi_defconfig";
    targetPlatforms = ["armv6l-linux"];
    filesToInstall = ["u-boot.bin"];
  };

  ubootRaspberryPi2 = buildUBoot rec {
    defconfig = "rpi_2_defconfig";
    targetPlatforms = ["armv7l-linux"];
    filesToInstall = ["u-boot.bin"];
  };

  ubootRaspberryPi3_32bit = buildUBoot rec {
    defconfig = "rpi_3_32b_defconfig";
    targetPlatforms = ["armv7l-linux"];
    filesToInstall = ["u-boot.bin"];
  };

  ubootRaspberryPi3_64bit = buildUBoot rec {
    defconfig = "rpi_3_defconfig";
    targetPlatforms = ["aarch64-linux"];
    filesToInstall = ["u-boot.bin"];
  };

  ubootUtilite = buildUBoot rec {
    defconfig = "cm_fx6_defconfig";
    targetPlatforms = ["armv7l-linux"];
    filesToInstall = ["u-boot-with-nand-spl.imx"];
    buildFlags = "u-boot-with-nand-spl.imx";
    postConfigure = ''
      cat >> .config << EOF
      CONFIG_CMD_SETEXPR=y
      EOF
    '';
    # sata init; load sata 0 $loadaddr u-boot-with-nand-spl.imx
    # sf probe; sf update $loadaddr 0 80000
  };

  ubootWandboard = buildUBoot rec {
    defconfig = "wandboard_defconfig";
    targetPlatforms = ["armv7l-linux"];
    filesToInstall = ["u-boot.img" "SPL"];
  };
}
