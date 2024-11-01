{ lib, stdenvNoCC, fetchFromGitHub }:

stdenvNoCC.mkDerivation rec {
  # NOTE: this should be updated with linux_rpi
  pname = "raspberrypi-firmware";
  version = "1.20240926";

  src = fetchFromGitHub {
    owner = "raspberrypi";
    repo = "firmware";
    rev = version;
    hash = "sha256-MCutxzdSFoZ4hn2Fxk2AHHgWCt/Jgc+reqJZHUuSKOc=";
  };

  installPhase = ''
    mkdir -p $out/share/raspberrypi/
    mv boot "$out/share/raspberrypi/"
  '';

  dontConfigure = true;
  dontBuild = true;
  dontFixup = true;

  meta = with lib; {
    description = "Firmware for the Raspberry Pi board";
    homepage = "https://github.com/raspberrypi/firmware";
    license = licenses.unfreeRedistributableFirmware; # See https://github.com/raspberrypi/firmware/blob/master/boot/LICENCE.broadcom
    maintainers = with maintainers; [ dezgeg ];
    # Hash mismatch on source, mystery.
    # Maybe due to https://github.com/NixOS/nix/issues/847
    broken = stdenvNoCC.hostPlatform.isDarwin;
  };
}
