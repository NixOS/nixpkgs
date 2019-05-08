{ stdenvNoCC, raspberrypifw }:

stdenvNoCC.mkDerivation {
  name = "raspberrypi-dtbs-${raspberrypifw.version}";
  nativeBuildInputs = [ raspberrypifw ];
  buildCommand = ''
    mkdir -p $out/broadcom/
    cp ${raspberrypifw}/share/raspberrypi/boot/bcm*.dtb $out/broadcom
  '';
  passthru = {
    # Compatible overlays that may be used
    overlays = "${raspberrypifw}/share/raspberrypi/boot/overlays";
  };
}
