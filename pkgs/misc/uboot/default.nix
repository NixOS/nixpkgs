{ stdenv, fetchurl, bc, dtc }:

let
  buildUBoot = { targetPlatforms
            , filesToInstall
            , installDir ? "$out"
            , defconfig
            , extraMeta ? {}
            , ... } @ args:
           stdenv.mkDerivation (rec {

    name = "uboot-${defconfig}-${version}";
    version = "2016.05";

    src = fetchurl {
      url = "ftp://ftp.denx.de/pub/u-boot/u-boot-${version}.tar.bz2";
      sha256 = "0wdivib8kbm17qr6r7n7wyzg5vnwpagvwk5m0z80rbssc5sj5l47";
    };

    nativeBuildInputs = [ bc dtc ];

    hardeningDisable = [ "all" ];

    configurePhase = ''
      make ${defconfig}
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p ${installDir}
      cp ${stdenv.lib.concatStringsSep " " filesToInstall} ${installDir}

      runHook postInstall
    '';

    dontStrip = true;

    crossAttrs = {
      makeFlags = [
        "ARCH=${stdenv.cross.platform.kernelArch}"
        "CROSS_COMPILE=${stdenv.cross.config}-"
      ];
    };

    meta = with stdenv.lib; {
      homepage = "http://www.denx.de/wiki/U-Boot/";
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

  ubootRaspberryPi3 = buildUBoot rec {
    defconfig = "rpi_3_32b_defconfig";
    targetPlatforms = ["armv7l-linux"];
    filesToInstall = ["u-boot.bin"];
  };

  ubootWandboard = buildUBoot rec {
    defconfig = "wandboard_defconfig";
    targetPlatforms = ["armv7l-linux"];
    filesToInstall = ["u-boot.img" "SPL"];
  };
}
