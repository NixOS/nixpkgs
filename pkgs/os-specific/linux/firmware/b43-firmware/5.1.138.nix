{
  lib,
  stdenvNoCC,
  fetchurl,
  b43FirmwareCutter,
}:

let
  version = "5.100.138";
in

stdenvNoCC.mkDerivation {
  pname = "b43-firmware";
  inherit version;

  src = fetchurl {
    url = "http://www.lwfinger.com/b43-firmware/broadcom-wl-${version}.tar.bz2";
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
  };
}
