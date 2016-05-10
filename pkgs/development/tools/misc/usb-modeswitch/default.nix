{ stdenv, fetchurl, pkgconfig, libusb1 }:

let
   version = "2.3.0";
in

stdenv.mkDerivation rec {
  name = "usb-modeswitch-${version}";

  src = fetchurl {
    url = "http://www.draisberghof.de/usb_modeswitch/${name}.tar.bz2";
    sha256 = "1jqih1g0y78w03rchpw7fjvzwjfakak61qjp7hbr1m5nnsh2dn9p";
  };

  # make clean: we always build from source. It should be necessary on x86_64 only
  preConfigure = ''
    find -type f | xargs sed 's@/bin/rm@rm@g' -i
    make clean
    mkdir -p $out/{etc,lib/udev,share/man/man1}
    makeFlags="DESTDIR=$out PREFIX=$out"
  '';

  buildInputs = [ pkgconfig libusb1 ];

  meta = {
    license = stdenv.lib.licenses.gpl2;
    maintainers = [ stdenv.lib.maintainers.marcweber ];
    platforms = stdenv.lib.platforms.linux;
  };
}
