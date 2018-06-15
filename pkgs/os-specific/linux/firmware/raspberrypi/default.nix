{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "raspberrypi-firmware-${version}";
  version = "1.20180417";

  src = fetchFromGitHub {
    owner = "raspberrypi";
    repo = "firmware";
    rev = version;
    sha256 = "17mnnhni0wgdnc3mw60nfhcj9v6p5dwcqkwnbpvzczab3r2hziji";
  };

  installPhase = ''
    mkdir -p $out/share/raspberrypi/boot
    cp -R boot/* $out/share/raspberrypi/boot
  '';

  meta = with stdenv.lib; {
    description = "Firmware for the Raspberry Pi board";
    homepage = https://github.com/raspberrypi/firmware;
    license = licenses.unfreeRedistributableFirmware; # See https://github.com/raspberrypi/firmware/blob/master/boot/LICENCE.broadcom
    platforms = [ "armv6l-linux" "armv7l-linux" "aarch64-linux" ];
    maintainers = with maintainers; [ dezgeg viric tavyc ];
  };
}
