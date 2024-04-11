{ stdenv, lib, buildPackages, fetchFromGitHub, fetchpatch, perl, buildLinux, rpiVersion, ... } @ args:

let
  # NOTE: raspberrypifw & raspberryPiWirelessFirmware should be updated with this
  modDirVersion = "6.1.63";
  tag = "stable_20231123";
in
lib.overrideDerivation (buildLinux (args // {
  version = "${modDirVersion}-${tag}";
  inherit modDirVersion;

  src = fetchFromGitHub {
    owner = "raspberrypi";
    repo = "linux";
    rev = tag;
    hash = "sha256-4Rc57y70LmRFwDnOD4rHoHGmfxD9zYEAwYm9Wvyb3no=";
  };

  defconfig = {
    "1" = "bcmrpi_defconfig";
    "2" = "bcm2709_defconfig";
    "3" = if stdenv.hostPlatform.isAarch64 then "bcmrpi3_defconfig" else "bcm2709_defconfig";
    "4" = "bcm2711_defconfig";
  }.${toString rpiVersion};

  features = {
    efiBootStub = false;
  } // (args.features or {});

  kernelPatches = (args.kernelPatches or []) ++ [
    # Fix "WARNING: unmet direct dependencies detected for MFD_RP1", and
    # subsequent build failure.
    # https://github.com/NixOS/nixpkgs/pull/268280#issuecomment-1911839809
    # https://github.com/raspberrypi/linux/pull/5900
    {
      name = "drm-rp1-depends-on-instead-of-select-MFD_RP1.patch";
      patch = fetchpatch {
        url = "https://github.com/peat-psuwit/rpi-linux/commit/6de0bb51929cd3ad4fa27b2a421a2af12e6468f5.patch";
        hash = "sha256-9pHcbgWTiztu48SBaLPVroUnxnXMKeCGt5vEo9V8WGw=";
      };
    }

    # Fix `ERROR: modpost: missing MODULE_LICENSE() in <...>/bcm2712-iommu.o`
    # by preventing such code from being built as module.
    # https://github.com/NixOS/nixpkgs/pull/284035#issuecomment-1913015802
    # https://github.com/raspberrypi/linux/pull/5910
    {
      name = "iommu-bcm2712-don-t-allow-building-as-module.patch";
      patch = fetchpatch {
        url = "https://github.com/peat-psuwit/rpi-linux/commit/693a5e69bddbcbe1d1b796ebc7581c3597685b1b.patch";
        hash = "sha256-8BYYQDM5By8cTk48ASYKJhGVQnZBIK4PXtV70UtfS+A=";
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
    dtbDir=${if stdenv.isAarch64 then "$out/dtbs/broadcom" else "$out/dtbs"}
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
    copyDTB bcm2710-rpi-3-b.dtb bcm2837-rpi-3-b.dtb
    copyDTB bcm2710-rpi-3-b-plus.dtb bcm2837-rpi-3-a-plus.dtb
    copyDTB bcm2710-rpi-3-b-plus.dtb bcm2837-rpi-3-b-plus.dtb
    copyDTB bcm2710-rpi-cm3.dtb bcm2837-rpi-cm3.dtb
    copyDTB bcm2711-rpi-4-b.dtb bcm2838-rpi-4-b.dtb
  '';
})
