{stdenv, fetchurl, pkgconfig, libusb}:

let

  # Obtained from http://www.linux-usb.org/usb.ids.bz2.
  usbids = fetchurl {
    url = http://nixos.org/tarballs/usb.ids.20090808.bz2;
    sha256 = "1007p5cm3k6vdsfrkwy92yvscazycz71k8wx32jygr50qsv1advj";
  };

in

stdenv.mkDerivation rec {
  name = "usbutils-0.84";
  
  src = fetchurl {
    url = "mirror://sourceforge/linux-usb/${name}.tar.gz";
    sha256 = "1aksgfsnxq43q3aas4cwhmy34ik3h2sg4iv2al9vz2v9aqnib83n";
  };
  
  buildInputs = [pkgconfig libusb];
  
  preBuild = "bunzip2 < ${usbids} > usb.ids";

  meta = {
    homepage = http://www.linux-usb.org/;
    description = "Tools for working with USB devices, such as lsusb";
  };
}
