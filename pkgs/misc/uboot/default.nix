{ stdenv, fetchurl, bc, dtc, fetchFromGitHub }:

let
  common = { targetPlatforms
            , filesToInstall
            , defconfig
            , version ? "2015.10"
            , extraMeta ? {}
            , ... } @ args:
           stdenv.mkDerivation (rec {

    name = "uboot-${defconfig}-${version}";
    installDir = "$out";

    nativeBuildInputs = [ bc dtc ];

    src = fetchurl {
      url = "ftp://ftp.denx.de/pub/u-boot/u-boot-${version}.tar.bz2";
      sha256 = "0m8r08izci0lzzjn5c5g5manp2rc7yc5swww0lxr7bamjigqvimx";
    };

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
      makeFlags = ''
        ARCH=${stdenv.cross.platform.kernelArch}
        CROSS_COMPILE=${stdenv.cross.config}-
        '';
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
  # Upstream U-Boots:
  ubootTools = common rec {
    installDir = "$out/bin";
    buildFlags = "tools NO_SDL=1";
    dontStrip = false;
    targetPlatforms = stdenv.lib.platforms.linux;
    filesToInstall = ["tools/dumpimage" "tools/mkenvimage" "tools/mkimage"];
  };

  ubootJetsonTK1 = common rec {
    defconfig = "jetson-tk1_defconfig";
    targetPlatforms = ["armv7l-linux"];
    filesToInstall = ["u-boot" "u-boot.dtb" "u-boot-dtb-tegra.bin" "u-boot-nodtb-tegra.bin"];
  };

  ubootPcduino3Nano = common rec {
    defconfig = "Linksprite_pcDuino3_Nano_defconfig";
    targetPlatforms = ["armv7l-linux"];
    filesToInstall = ["u-boot-sunxi-with-spl.bin"];
  };

  ubootRaspberryPi = common rec {
    defconfig = "rpi_defconfig";
    targetPlatforms = ["armv6l-linux"];
    filesToInstall = ["u-boot.bin"];
  };


  # Intended only for QEMU's vexpress-a9 emulation target!
  ubootVersatileExpressCA9 = common rec {
    defconfig = "vexpress_ca9x4_defconfig";
    targetPlatforms = ["armv7l-linux"];
    filesToInstall = ["u-boot"];
    patches = [ ./vexpress-Use-config_distro_bootcmd.patch ];
  };
}
