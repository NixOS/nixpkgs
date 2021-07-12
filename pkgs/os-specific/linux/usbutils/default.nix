{ lib, stdenv, fetchurl, substituteAll, autoreconfHook, pkg-config, libusb1, hwdata , python3 }:

stdenv.mkDerivation rec {
  name = "usbutils-013";

  src = fetchurl {
    url = "mirror://kernel/linux/utils/usb/usbutils/${name}.tar.xz";
    sha256 = "0f0klk6d3hmbpf6p4dcwa1qjzblmkhbxs1wsw87aidvqri7lj8wy";
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
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
