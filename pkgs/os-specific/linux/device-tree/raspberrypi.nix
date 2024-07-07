{ lib, stdenvNoCC, raspberrypifw }:

stdenvNoCC.mkDerivation {
  pname = "raspberrypi-dtbs";
  version = raspberrypifw.version;
  nativeBuildInputs = [ raspberrypifw ];

  # Rename DTBs so u-boot finds them, like linux-rpi.nix
  buildCommand = ''
    mkdir -p $out/broadcom/
    cd $out/broadcom/

    cp ${raspberrypifw}/share/raspberrypi/boot/bcm*.dtb .

    cp bcm2708-rpi-zero-w.dtb bcm2835-rpi-zero-w.dtb
    cp bcm2708-rpi-b.dtb bcm2835-rpi-a.dtb
    cp bcm2708-rpi-b.dtb bcm2835-rpi-b.dtb
    cp bcm2708-rpi-b.dtb bcm2835-rpi-b-rev2.dtb
    cp bcm2708-rpi-b-plus.dtb bcm2835-rpi-a-plus
    cp bcm2708-rpi-b-plus.dtb bcm2835-rpi-b-plus
    cp bcm2708-rpi-b-plus.dtb bcm2835-rpi-zero.dtb
    cp bcm2708-rpi-cm.dtb bcm2835-rpi-cm.dtb
    cp bcm2709-rpi-2-b.dtb bcm2836-rpi-2-b.dtb
    cp bcm2710-rpi-3-b.dtb bcm2837-rpi-3-b.dtb
    cp bcm2710-rpi-3-b-plus.dtb bcm2837-rpi-3-b-plus.dtb
    cp bcm2710-rpi-cm3.dtb bcm2837-rpi-cm3.dtb
    cp bcm2711-rpi-4-b.dtb bcm2838-rpi-4-b.dtb
  '';

  passthru = {
    # Compatible overlays that may be used
    overlays = "${raspberrypifw}/share/raspberrypi/boot/overlays";
  };
  meta = with lib; {
    inherit (raspberrypifw.meta) homepage license;
    description = "DTBs for the Raspberry Pi";
  };
}
