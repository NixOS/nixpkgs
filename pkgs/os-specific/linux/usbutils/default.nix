{stdenv, fetchurl, libusb}:

let

  usbids = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/usb.ids.20061212.bz2;
    sha256 = "112l4fzjn5p3y6fv3x10vbrd36n2v5n04s7pjdlkb2yqv4crp84m";
  };

in

stdenv.mkDerivation {
  name = "usbutils-0.72";
  src = fetchurl {
    url = mirror://sourceforge/linux-usb/usbutils-0.72.tar.gz;
    sha256 = "08s4g4sz7p3a1afvphxd7h5bbfywvp0j611y85wbhwr14i9m6f00";
  };
  buildInputs = [libusb];
  preBuild = "bunzip2 < ${usbids} > usb.ids";
}
