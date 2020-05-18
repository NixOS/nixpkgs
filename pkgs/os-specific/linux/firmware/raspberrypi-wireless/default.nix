{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation {
  pname = "raspberrypi-wireless-firmware";
  version = "2020-04-17";

  srcs = [
    (fetchFromGitHub {
      name = "bluez-firmware";
      owner = "RPi-Distro";
      repo = "bluez-firmware";
      rev = "fff76cb15527c435ce99a9787848eacd6288282c";
      sha256 = "0wflk5cwxi2x82n633j89fqjydajn1f6dm8lrghs9gqdy16xpz32";
    })
    (fetchFromGitHub {
      name = "firmware-nonfree";
      owner = "RPi-Distro";
      repo = "firmware-nonfree";
      rev = "616fc2dd4df421e3974179d9e46d45e7006aeb28";
      sha256 = "1aa95szbn7gii4zm9daimcikmbqjmppj0zn4nfr1ms7yladbjsdm";
    })
  ];

  sourceRoot = ".";

  dontBuild = true;
  # Firmware blobs do not need fixing and should not be modified
  dontFixup = true;

  installPhase = ''
    mkdir -p "$out/lib/firmware/brcm"

    # Wifi firmware
    for filename in firmware-nonfree/brcm/brcmfmac434??-sdio.*; do
      cp "$filename" "$out/lib/firmware/brcm"
    done

    # Bluetooth firmware
    cp bluez-firmware/broadcom/*.hcd "$out/lib/firmware/brcm"
  '';

  outputHashMode = "recursive";
  outputHashAlgo = "sha256";
  outputHash = "0ifjivysipf8al133r9a35ls1lf34z0nyh2p61zlr6j9w8nfspnz";

  meta = with stdenv.lib; {
    description = "Firmware for builtin Wifi/Bluetooth devices in the Raspberry Pi 3 and Zero W";
    homepage = "https://github.com/RPi-Distro/firmware-nonfree";
    license = licenses.unfreeRedistributableFirmware;
    platforms = platforms.linux;
    maintainers = with maintainers; [ lopsided98 ];
  };
}
