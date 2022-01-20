{ lib, stdenvNoCC, fetchurl, unzip }:

let
  rev = "cfdbadea5f74c16b7ed5d3b4866092a054e3c3bf";
in stdenvNoCC.mkDerivation rec {
  # NOTE: this should be updated with linux_rpi
  pname = "raspberrypi-firmware";
  # not a versioned tag, but this is what the "stable"
  # branch points to, as of 2022-01-10
  version = "20220106";

  src = fetchurl {
    url = "https://github.com/raspberrypi/firmware/archive/${rev}.zip";
    sha256 = "sha256-llRztlI2bokCosyEJOrmH+NLl/f2H+01/+xNBcxqXn0=";
    postFetch = "true";
  };

  nativeBuildInputs = [ unzip ];

  installPhase = ''
    mkdir -p $out/share/raspberrypi/
    unzip "$src"
    mv "firmware-${rev}/boot" "$out/share/raspberrypi/"
  '';

  dontConfigure = true;
  dontBuild = true;
  dontFixup = true;

  meta = with lib; {
    description = "Firmware for the Raspberry Pi board";
    homepage = "https://github.com/raspberrypi/firmware";
    license = licenses.unfreeRedistributableFirmware; # See https://github.com/raspberrypi/firmware/blob/master/boot/LICENCE.broadcom
    maintainers = with maintainers; [ dezgeg ];
  };
}
