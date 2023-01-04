{ lib, stdenvNoCC, fetchFromGitHub }:

let verinfo = {
  version = "2023-01-04";
  rev = "03e04372dea46d38e42d3208a11f8ee37bff09bf";
  hash = "sha256-jt4CJ5IZksJKPZF1wNhwLHlreGXJfeuuF29CRpx67gw=";
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
