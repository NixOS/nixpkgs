{ lib, stdenvNoCC, fetchFromGitHub }:

let verinfo = {
  version = "2022-12-19";
  rev = "4849b548c1ffda841481c54e62fff249ed00b32c";
  hash = "sha256-us8pQmJn16YwfVpE3CPVh9vqV0PxFI9MBhzko2AFg3M=";
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
