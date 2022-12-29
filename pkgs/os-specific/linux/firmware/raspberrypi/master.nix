{ lib, stdenvNoCC, fetchFromGitHub }:

let verinfo = {
  version = "2022-11-15";
  rev = "494eb71e5adfca31ec65dd535fce73de3c7c2efa";
  hash = "sha256-ybJmHFAPMuqLs4gbr2VuJA1ET5eaSVfU9/Gfib7n/PM=";
}; in
stdenvNoCC.mkDerivation rec {
  # NOTE: this should be updated with linux_rpi
  pname = "raspberrypi-firmware-master";
  # not a versioned tag, but this is "stable" as of 2022-01-10
  version = verinfo.version;

  src = fetchFromGitHub {
    owner = "raspberrypi";
    repo = "firmware";
    inherit (verinfo) rev hash;
  };

  installPhase = ''
    mkdir -p $out/share/raspberrypi/
    mv boot "$out/share/raspberrypi/"
  '';

  dontConfigure = true;
  dontBuild = true;
  dontFixup = true;

  passthru.verinfo = verinfo;

  meta = with lib; {
    description = "Firmware for the Raspberry Pi board (unstable master branch)";
    homepage = "https://github.com/raspberrypi/firmware";
    license = licenses.unfreeRedistributableFirmware; # See https://github.com/raspberrypi/firmware/blob/master/boot/LICENCE.broadcom
    maintainers = with maintainers; [ dezgeg ];
    broken = stdenvNoCC.isDarwin; # Hash mismatch on source, mystery.
  };
}
