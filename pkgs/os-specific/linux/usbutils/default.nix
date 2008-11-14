{stdenv, fetchurl, libusb}:

let

  usbids = fetchurl {
    url = http://nixos.org/tarballs/usb.ids.20080115.bz2;
    sha256 = "0xymp8fpp9pnkj2i4ry8zpsvy18zw14sx03pnz316lpgwc6dx12n";
  };

in

stdenv.mkDerivation {
  name = "usbutils-0.73";
  src = fetchurl {
    url = mirror://sourceforge/linux-usb/usbutils-0.73.tar.gz;
    sha256 = "1x27mc2apyipf8fa2ac49rfnkm7f5dwv784b1ncgc5yjiz4prp1f";
  };
  buildInputs = [libusb];
  preBuild = "bunzip2 < ${usbids} > usb.ids";
}
