{ stdenv, fetchurl, substituteAll, autoreconfHook, pkgconfig, libusb1, hwdata , python3 }:

stdenv.mkDerivation rec {
  name = "usbutils-010";

  src = fetchurl {
    url = "mirror://kernel/linux/utils/usb/usbutils/${name}.tar.xz";
    sha256 = "06aag4jfgsfjxk563xsp9ik9nadihmasrr37a1gb0vwqni5kdiv1";
  };

  patches = [
    (substituteAll {
      src = ./fix-paths.patch;
      inherit hwdata;
    })
  ];

  nativeBuildInputs = [ autoreconfHook pkgconfig ];
  buildInputs = [ libusb1 python3 ];

  outputs = [ "out" "man" "python" ];
  postInstall = ''
    moveToOutput "bin/lsusb.py" "$python"
  '';

  meta = with stdenv.lib; {
    homepage = http://www.linux-usb.org/;
    description = "Tools for working with USB devices, such as lsusb";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
