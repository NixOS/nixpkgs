{stdenv, fetchurl, kernel}:

stdenv.mkDerivation {
  name = "qc-usb-0.6.3";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://surfnet.dl.sourceforge.net/sourceforge/qce-ga/qc-usb-0.6.3.tar.gz;
    md5 = "3d33380a29a7f92c4eef1f82d61b4ee0";
  };
  inherit kernel;
  patches = [./quickcam-install.patch];
}
