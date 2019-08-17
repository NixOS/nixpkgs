{ stdenv, lib, buildPackages, fetchFromGitHub, perl, buildLinux, rpiVersion, ... } @ args:

let
  modDirVersion = "4.19.66";
in
lib.overrideDerivation (buildLinux (args // {
  version = "${modDirVersion}-20190817";
  inherit modDirVersion;
  # It seems like the sed below should fix this, and does something similar for
  # -v7. I can't figure out why it doesn't. This works, though.
  #modDirVersion = version + lib.optionalString
  #  (stdenv.hostPlatform.system == "aarch64-linux") "-v8";
  src = fetchFromGitHub {
    owner = "yaroslavros";
    repo = "linux";
    rev = "5adf84b5522b0cf14f6d1832379105c4482cad7d";
    sha256 = "0phv96krc8l1wd1lb5qkfq8bmmy7baypxlqsb9slqwm00b6s2lrr";
  };

  defconfig = {
    "0" = "bcmrpi_defconfig";
    "1" = "bcmrpi_defconfig";
    "2" = "bcm2709_defconfig";
    "3" = "bcmrpi3_defconfig";
    "4" = "bcm2711_defconfig";
  }.${toString rpiVersion};

  features = {
    efiBootStub = false;
  } // (args.features or {});

  extraMeta = if (rpiVersion < 3) then {
    platforms = with lib.platforms; [ arm ];
    hydraPlatforms = [];
  } else {
    platforms = with lib.platforms; [ arm aarch64 ];
    hydraPlatforms = [ "aarch64-linux" ];
  };
})) (oldAttrs: {
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
    copyDTB bcm2708-rpi-0-w.dtb bcm2835-rpi-zero.dtb
    copyDTB bcm2708-rpi-0-w.dtb bcm2835-rpi-zero-w.dtb
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
    copyDTB bcm2710-rpi-3-b.dtb bcm2837-rpi-3-b.dtb
    copyDTB bcm2710-rpi-3-b-plus.dtb bcm2837-rpi-3-b-plus.dtb
    copyDTB bcm2710-rpi-cm3.dtb bcm2837-rpi-cm3.dtb
    copyDTB bcm2711-rpi-4-b.dtb bcm2838-rpi-4-b.dtb
  '';
})
