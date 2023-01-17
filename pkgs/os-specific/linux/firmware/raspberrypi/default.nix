{ lib, stdenvNoCC, fetchFromGitHub
, verinfo ? {
    version = "2023-01-06";
    rev = "78852e166b4cf3ebb31d051e996d54792f0994b0";
    hash = "sha256-tdaH+zZwmILNFBge2gMqtzj/1Hydj9cxhPvhw+7jTrU=";
  }
}:

stdenvNoCC.mkDerivation rec {
  # NOTE: this should be updated with linux_rpi
  pname = "raspberrypi-firmware";
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
    description = "Firmware for the Raspberry Pi board";
    homepage = "https://github.com/raspberrypi/firmware";
    license = licenses.unfreeRedistributableFirmware; # See https://github.com/raspberrypi/firmware/blob/master/boot/LICENCE.broadcom
    maintainers = with maintainers; [ dezgeg ];
    broken = stdenvNoCC.isDarwin; # Hash mismatch on source, mystery.
  };
}
