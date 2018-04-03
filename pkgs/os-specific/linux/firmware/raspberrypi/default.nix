{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "raspberrypi-firmware-${version}";
  version = "1.20180313";

  src = fetchFromGitHub {
    owner = "raspberrypi";
    repo = "firmware";
    rev = version;
    sha256 = "0h6zbkwm5n640vap4zs9fwplfq13cqnsksw46sxijzg9g0jhlv9n";
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
