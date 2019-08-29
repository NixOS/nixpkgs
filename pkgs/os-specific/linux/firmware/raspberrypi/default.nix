{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "raspberrypi-firmware";
  version = "1.20190620+1";

  src = fetchFromGitHub {
    owner = "raspberrypi";
    repo = "firmware";
    rev = version;
    sha256 = "0gbqlkr50qlmbpwr0n61pb58w0k3sfjfirh2y683rlkp5rlq7mrf";
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
