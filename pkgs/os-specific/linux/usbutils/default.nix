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
  postInstall = ''
    moveToOutput "bin/lsusb.py" "$python"
  '';

  meta = with lib; {
    homepage = "http://www.linux-usb.org/";
    description = "Tools for working with USB devices, such as lsusb";
    maintainers = with maintainers; [ ];
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
