{ lib, stdenv, fetchurl, substituteAll, autoreconfHook, pkg-config, libusb1, hwdata, python3 }:

stdenv.mkDerivation rec {
  pname = "usbutils";
  version = "015";

  src = fetchurl {
    url = "mirror://kernel/linux/utils/usb/usbutils/usbutils-${version}.tar.xz";
    sha256 = "sha256-w7RRux9P+fY1bKxaaVaprI6F2BZRr1ainmiflPpv2m4=";
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
