{stdenv, fetchurl }:

stdenv.mkDerivation {
  name = "raspberrypi-firmware-20160106";

  src = fetchurl {
    url = "https://github.com/raspberrypi/firmware/archive/4ade27942e.tar.gz";
    sha256 = "0f4p920vr7dcj4hprgil8baqqbnsjx1jykz0pkdx29mqy0n0xanl";
  };

  installPhase = ''
    mkdir -p $out/share/raspberrypi/boot
    cp -R boot/* $out/share/raspberrypi/boot
    cp -R hardfp/opt/vc/* $out
    cp opt/vc/LICENCE $out/share/raspberrypi
  '';
  
  meta = {
    description = "Firmware for the Raspberry Pi board";
    homepage = https://github.com/raspberrypi;
    license = "non-free";
  };
}
