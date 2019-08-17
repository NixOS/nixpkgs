{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "raspberrypi-firmware";
  version = "1.20190718";

  src = fetchFromGitHub {
    owner = "raspberrypi";
    repo = "firmware";
    rev = version;
    sha256 = "1ip478igvc4y9ffgd6gaw3qln3y1y2lhwzqfz0y2srwxfpniwma4";
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
    maintainers = with maintainers; [ dezgeg tavyc ];
  };
}
