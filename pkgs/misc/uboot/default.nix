{ stdenv, fetchFromGitHub, fetchpatch, bc, dtc, openssl, python2
, hostPlatform
}:

let
  buildUBoot = { targetPlatforms
            , filesToInstall
            , installDir ? "$out"
            , defconfig
            , extraMakeFlags ? []
            , extraMeta ? {}
            , ... } @ args:
           stdenv.mkDerivation (rec {

    name = "uboot-${defconfig}-${version}";
    version = "v2018.03-rc3";

    src = fetchFromGitHub {
      owner = "u-boot";
      repo = "u-boot";
      rev = version;
      sha256 = "056md2nx31p4mfnw01cps3kwpla3nm5q4khjfi3c98mf10csj8lc";
    };

    patches = [
      (fetchpatch {
        url = https://github.com/dezgeg/u-boot/commit/cbsize-2017-11.patch;
        sha256 = "08rqsrj78aif8vaxlpwiwwv1jwf0diihbj0h88hc0mlp0kmyqxwm";
      })
      (fetchpatch {
        url = https://github.com/dezgeg/u-boot/commit/rpi-2017-11-patch1.patch;
        sha256 = "067yq55vv1slv4xy346px7h329pi14abdn04chg6s1s6hmf6c1x9";
      })
      (fetchpatch {
        url = https://github.com/dezgeg/u-boot/commit/rpi-2017-11-patch2.patch;
        sha256 = "0bbw0q027xvzvdxxvpzjajg4rm30a8mb7z74b6ma9q0l7y7bi0c4";
      })
      (fetchpatch {
        url = https://github.com/bendlas/u-boot/compare/f0f6917188ad660cf002c10095f46ecf748b8f58...d35c38015ea73db01466586ba7746f4a1fbf3890.patch;
        sha256 = "1q0mxk1az11kqggylammdz4f2rwhv2vwcwx8ql19k1w9ys5w9x0a";
      })
    ];

    postPatch = ''
      patchShebangs tools
    '';

    nativeBuildInputs = [ bc dtc openssl python2 ];

    hardeningDisable = [ "all" ];

    makeFlags = [ "DTC=dtc" ] ++ extraMakeFlags;

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
    # build tools/kwboot
    extraMakeFlags = [ "CONFIG_KIRKWOOD=y" ];
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

  # http://git.denx.de/?p=u-boot.git;a=blob;f=board/solidrun/clearfog/README;hb=refs/heads/master
  ubootClearfog = buildUBoot rec {
    defconfig = "clearfog_defconfig";
    targetPlatforms = ["armv7l-linux"];
    filesToInstall = ["u-boot-spl.kwb"];
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

  ubootOrangePiPc = buildUBoot rec {
    defconfig = "orangepi_pc_defconfig";
    targetPlatforms = ["armv7l-linux"];
    filesToInstall = ["u-boot-sunxi-with-spl.bin"];
  };

  ubootPcduino3Nano = buildUBoot rec {
    defconfig = "Linksprite_pcDuino3_Nano_defconfig";
    targetPlatforms = ["armv7l-linux"];
    filesToInstall = ["u-boot-sunxi-with-spl.bin"];
  };

  ubootQemuArm_32bit = buildUBoot rec {
    defconfig = "qemu_arm_defconfig";
    targetPlatforms = ["armv7l-linux"];
    filesToInstall = ["u-boot.bin"];
  };

  ubootQemuArm_64bit = buildUBoot rec {
    defconfig = "qemu_arm64_defconfig";
    targetPlatforms = ["aarch64-linux"];
    filesToInstall = ["u-boot.bin"];
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
