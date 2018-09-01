{ stdenv, buildPackages, fetchFromGitHub, perl, buildLinux, ... } @ args:

let
  modDirVersion = "4.14.50";
  tag = "1.20180619";
in
stdenv.lib.overrideDerivation (buildLinux (args // rec {
  version = "${modDirVersion}-${tag}";
  inherit modDirVersion;

  src = fetchFromGitHub {
    owner = "raspberrypi";
    repo = "linux";
    rev = "raspberrypi-kernel_${tag}-1";
    sha256 = "0yccz8j3vrzv6h23b7yn7dx84kkzq3dmicm3shhz18nkpyyq71ch";
  };

  defconfig = {
    "armv6l-linux" = "bcmrpi_defconfig";
    "armv7l-linux" = "bcm2709_defconfig";
  }.${stdenv.hostPlatform.system} or (throw "linux_rpi not supported on '${stdenv.hostPlatform.system}'");

  features = {
    efiBootStub = false;
  } // (args.features or {});

  extraMeta.hydraPlatforms = [];
})) (oldAttrs: {
  postConfigure = ''
    # The v7 defconfig has this set to '-v7' which screws up our modDirVersion.
    sed -i $buildRoot/.config -e 's/^CONFIG_LOCALVERSION=.*/CONFIG_LOCALVERSION=""/'
  '';

  postFixup = ''
    # Make copies of the DTBs named after the upstream names so that U-Boot finds them.
    # This is ugly as heck, but I don't know a better solution so far.
    rm $out/dtbs/bcm283*.dtb
    copyDTB() {
      cp -v "$out/dtbs/$1" "$out/dtbs/$2"
    }

    copyDTB bcm2708-rpi-0-w.dtb bcm2835-rpi-zero.dtb
    copyDTB bcm2708-rpi-0-w.dtb bcm2835-rpi-zero-w.dtb
    copyDTB bcm2708-rpi-b.dtb bcm2835-rpi-a.dtb
    copyDTB bcm2708-rpi-b.dtb bcm2835-rpi-b.dtb
    copyDTB bcm2708-rpi-b.dtb bcm2835-rpi-b-rev2.dtb
    copyDTB bcm2708-rpi-b-plus.dtb bcm2835-rpi-a-plus.dtb
    copyDTB bcm2708-rpi-b-plus.dtb bcm2835-rpi-b-plus.dtb
    copyDTB bcm2708-rpi-b-plus.dtb bcm2835-rpi-zero.dtb
    copyDTB bcm2708-rpi-cm.dtb bcm2835-rpi-cm.dtb
    copyDTB bcm2709-rpi-2-b.dtb bcm2836-rpi-2-b.dtb
    copyDTB bcm2710-rpi-3-b.dtb bcm2837-rpi-3-b.dtb
    copyDTB bcm2710-rpi-3-b-plus.dtb bcm2837-rpi-3-b-plus.dtb
    copyDTB bcm2710-rpi-cm3.dtb bcm2837-rpi-cm3.dtb
  '';
})
