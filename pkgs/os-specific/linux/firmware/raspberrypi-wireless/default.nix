{ stdenv, fetchurl, dpkg }:

stdenv.mkDerivation rec {
  name = "raspberrypi-wireless-firmware-${version}";
  version = "2018-05-30";

  srcs = [
    (fetchurl {
      url = "https://archive.raspberrypi.org/debian/pool/main/b/bluez-firmware/bluez-firmware_1.2-3+rpt5.debian.tar.xz";
      sha256 = "06zpyrz6frkgjy26hr3998klnhjdqxwashgjgvj9rgbcqy70nkxg";
    })
    (fetchurl {
      url = "https://archive.raspberrypi.org/debian/pool/main/f/firmware-nonfree/firmware-brcm80211_20161130-3+rpt3_all.deb";
      sha256 = "10l74ac28baprnsiylf2vy4pkxgb3crixid90ngs6si9smm7rn6z";
    })
  ];

  sourceRoot = ".";
  dontBuild = true;
  # Firmware blobs do not need fixing and should not be modified
  dontFixup = true;


  # Unpack the debian package
  nativeBuildInputs = [ dpkg ];
  unpackCmd = ''
    if ! [[ "$curSrc" =~ \.deb$ ]]; then return 1; fi
    dpkg -x "$curSrc" .
  '';

  installPhase = ''
    mkdir -p "$out/lib/firmware/brcm"

    # Wifi firmware
    for filename in lib/firmware/brcm/brcmfmac434??-sdio.*; do
      cp "$filename" "$out/lib/firmware/brcm"
    done

    # Bluetooth firmware
    cp broadcom/*.hcd "$out/lib/firmware/brcm"
  '';

  outputHashMode = "recursive";
  outputHashAlgo = "sha256";
  outputHash = "1gwzasl5w5nc0awqv3w2081ns63wd1yds0xh0dg95dc6brnqhhf8";

  meta = with stdenv.lib; {
    description = "Firmware for builtin Wifi/Bluetooth devices in the Raspberry Pi 3 and Zero W";
    homepage = https://archive.raspberrypi.org/debian/pool/main/f/firmware-nonfree/;
    license = licenses.unfreeRedistributableFirmware;
    platforms = platforms.linux;
    maintainers = with maintainers; [ lopsided98 ];
  };
}
