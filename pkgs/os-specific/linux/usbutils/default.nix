{ lib, stdenv, fetchurl, substituteAll, autoreconfHook, pkg-config, libusb1, hwdata, python3 }:

stdenv.mkDerivation rec {
  pname = "usbutils";
  version = "017";

  src = fetchurl {
    url = "mirror://kernel/linux/utils/usb/usbutils/usbutils-${version}.tar.xz";
    hash = "sha256-pqJf/c+RA+ONekRzKsoXBz9OYCuS5K5VYlIxqCcC4Fs=";
  };

  patches = [
    (substituteAll {
      src = ./fix-paths.patch;
      inherit hwdata;
    })
  ];

  nativeBuildInputs = [ autoreconfHook pkg-config ];
  buildInputs = [ libusb1 python3 ];

  outputs = [ "out" "man" "python" ];

  postBuild = ''
    $CC $NIX_CFLAGS -o usbreset usbreset.c
  '';

  postInstall = ''
    moveToOutput "bin/lsusb.py" "$python"
    install -Dm555 usbreset -t $out/bin
  '';

  meta = {
    homepage = "http://www.linux-usb.org/";
    description = "Tools for working with USB devices, such as lsusb";
    maintainers = with lib.maintainers; [ cafkafk ];
    license = with lib.licenses; [
      gpl2Only # manpages, usbreset
      gpl2Plus # most of the code
     ];
    platforms = lib.platforms.linux;
    mainProgram = "lsusb";
  };
}
