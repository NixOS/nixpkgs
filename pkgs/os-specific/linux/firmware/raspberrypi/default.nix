{ lib, stdenvNoCC, fetchFromGitHub }:

stdenvNoCC.mkDerivation rec {
  # NOTE: this should be updated with linux_rpi
  pname = "raspberrypi-firmware";
  # not a versioned tag, but this is what the "stable"
  # branch points to, as of 2022-01-10
  version = "20220106";

  src = fetchFromGitHub {
    owner = "raspberrypi";
    repo = "firmware";
    rev = "cfdbadea5f74c16b7ed5d3b4866092a054e3c3bf";
    sha256 = "sha256-l7qyeCz4BzHLz+LMm4irCZU5j/khkW87S2Q2263e44Y=";
  };

  installPhase = ''
    mkdir -p $out/share/raspberrypi/boot
    cp -R boot/* $out/share/raspberrypi/boot
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
