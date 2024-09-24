{ stdenv, lib, buildPackages, fetchFromGitHub, fetchpatch, perl, buildLinux, rpiVersion, ... } @ args:

let
  # NOTE: raspberrypifw & raspberryPiWirelessFirmware should be updated with this
  modDirVersion = "6.6.31";
  tag = "stable_20240529";
in
lib.overrideDerivation (buildLinux (args // {
  version = "${modDirVersion}-${tag}";
  inherit modDirVersion;
  pname = "linux-rpi";

  src = fetchFromGitHub {
    owner = "raspberrypi";
    repo = "linux";
    rev = tag;
    hash = "sha256-UWUTeCpEN7dlFSQjog6S3HyEWCCnaqiUqV5KxCjYink=";
  };

  defconfig = {
    "1" = "bcmrpi_defconfig";
    "2" = "bcm2709_defconfig";
    "3" = if stdenv.hostPlatform.isAarch64 then "bcmrpi3_defconfig" else "bcm2709_defconfig";
    "4" = "bcm2711_defconfig";
  }.${toString rpiVersion};

  structuredExtraConfig = (args.structuredExtraConfig or {}) // (with lib.kernel; {
    # Workaround https://github.com/raspberrypi/linux/issues/6198
    # Needed because NixOS 24.05+ sets DRM_SIMPLEDRM=y which pulls in
    # DRM_KMS_HELPER=y.
    BACKLIGHT_CLASS_DEVICE = yes;
  });

  features = {
    efiBootStub = false;
  } // (args.features or {});

  kernelPatches = (args.kernelPatches or []) ++ [
    # Fix compilation errors due to incomplete patch backport.
    # https://github.com/raspberrypi/linux/pull/6223
    {
      name = "gpio-pwm_-_pwm_apply_might_sleep.patch";
      patch = fetchpatch {
        url = "https://github.com/peat-psuwit/rpi-linux/commit/879f34b88c60dd59765caa30576cb5bfb8e73c56.patch";
        hash = "sha256-HlOkM9EFmlzOebCGoj7lNV5hc0wMjhaBFFZvaRCI0lI=";
      };
    }

    {
      name = "ir-rx51_-_pwm_apply_might_sleep.patch";
      patch = fetchpatch {
        url = "https://github.com/peat-psuwit/rpi-linux/commit/23431052d2dce8084b72e399fce82b05d86b847f.patch";
        hash = "sha256-UDX/BJCJG0WVndP/6PbPK+AZsfU3vVxDCrpn1kb1kqE=";
      };
    }
  ];

  extraMeta = if (rpiVersion < 3) then {
    platforms = with lib.platforms; arm;
    hydraPlatforms = [];
  } else {
    platforms = with lib.platforms; arm ++ aarch64;
    hydraPlatforms = [ "aarch64-linux" ];
  };
} // (args.argsOverride or {}))) (oldAttrs: {
  postConfigure = ''
    # The v7 defconfig has this set to '-v7' which screws up our modDirVersion.
    sed -i $buildRoot/.config -e 's/^CONFIG_LOCALVERSION=.*/CONFIG_LOCALVERSION=""/'
    sed -i $buildRoot/include/config/auto.conf -e 's/^CONFIG_LOCALVERSION=.*/CONFIG_LOCALVERSION=""/'
  '';

  # Make copies of the DTBs named after the upstream names so that U-Boot finds them.
  # This is ugly as heck, but I don't know a better solution so far.
  postFixup = ''
    dtbDir=${if stdenv.hostPlatform.isAarch64 then "$out/dtbs/broadcom" else "$out/dtbs"}
    rm $dtbDir/bcm283*.dtb
    copyDTB() {
      cp -v "$dtbDir/$1" "$dtbDir/$2"
    }
  '' + lib.optionalString (lib.elem stdenv.hostPlatform.system ["armv6l-linux"]) ''
    copyDTB bcm2708-rpi-zero-w.dtb bcm2835-rpi-zero.dtb
    copyDTB bcm2708-rpi-zero-w.dtb bcm2835-rpi-zero-w.dtb
    copyDTB bcm2708-rpi-b.dtb bcm2835-rpi-a.dtb
    copyDTB bcm2708-rpi-b.dtb bcm2835-rpi-b.dtb
    copyDTB bcm2708-rpi-b.dtb bcm2835-rpi-b-rev2.dtb
    copyDTB bcm2708-rpi-b-plus.dtb bcm2835-rpi-a-plus.dtb
    copyDTB bcm2708-rpi-b-plus.dtb bcm2835-rpi-b-plus.dtb
    copyDTB bcm2708-rpi-b-plus.dtb bcm2835-rpi-zero.dtb
    copyDTB bcm2708-rpi-cm.dtb bcm2835-rpi-cm.dtb
  '' + lib.optionalString (lib.elem stdenv.hostPlatform.system ["armv7l-linux"]) ''
    copyDTB bcm2709-rpi-2-b.dtb bcm2836-rpi-2-b.dtb
  '' + lib.optionalString (lib.elem stdenv.hostPlatform.system ["armv7l-linux" "aarch64-linux"]) ''
    copyDTB bcm2710-rpi-zero-2.dtb bcm2837-rpi-zero-2.dtb
    copyDTB bcm2710-rpi-zero-2-w.dtb bcm2837-rpi-zero-2-w.dtb
    copyDTB bcm2710-rpi-3-b.dtb bcm2837-rpi-3-b.dtb
    copyDTB bcm2710-rpi-3-b-plus.dtb bcm2837-rpi-3-a-plus.dtb
    copyDTB bcm2710-rpi-3-b-plus.dtb bcm2837-rpi-3-b-plus.dtb
    copyDTB bcm2710-rpi-cm3.dtb bcm2837-rpi-cm3.dtb
    copyDTB bcm2711-rpi-4-b.dtb bcm2838-rpi-4-b.dtb
  '';
})
