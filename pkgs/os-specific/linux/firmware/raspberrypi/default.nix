{ lib, stdenvNoCC, fetchFromGitHub }:

stdenvNoCC.mkDerivation rec {
  # NOTE: this should be updated with linux_rpi
  pname = "raspberrypi-firmware";
  # raspberrypi/firmware no longers tag the releases. However, since each commit
  # on the stable branch corresponds to a tag in raspberrypi/linux repo, we
  # assume they are cut together.
  version = "stable_20231123";

  src = fetchFromGitHub {
    owner = "raspberrypi";
    repo = "firmware";
    rev = "524247ac6d8b1f4ddd53730e978a70c76a320bd6";
    hash = "sha256-rESwkR7pc5MTwIZ8PaMUPXuzxfv+jVpdRp8ijvxHGcg=";
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
    broken = stdenvNoCC.isDarwin;
  };
}
