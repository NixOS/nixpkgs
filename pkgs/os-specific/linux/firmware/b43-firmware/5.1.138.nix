{
  lib,
  stdenvNoCC,
  fetchurl,
  b43FirmwareCutter,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "b43-firmware";
  version = "5.100.138";

  src = fetchurl {
    url = "https://github.com/minios-linux/b43-firmware/releases/download/b43-firmware/broadcom-wl-${finalAttrs.version}.tar.bz2";
    hash = "sha256-8ecGeqxbYrZ7i25MUXmQJ3gEM5rBYGXrE8cx/5Ca5G8=";
  };

  nativeBuildInputs = [ b43FirmwareCutter ];

  installPhase = ''
    mkdir -p $out/lib/firmware
    b43-fwcutter -w $out/lib/firmware linux/wl_apsta.o
  '';

  meta = {
    description = "Firmware for cards supported by the b43 kernel module";
    homepage = "https://wireless.wiki.kernel.org/en/users/drivers/b43";
    license = lib.licenses.unfree;
    sourceProvenance = with lib.sourceTypes; [ binaryFirmware ];
  };
})
