{ stdenv, fetchurl, pkgconfig, libusb1 }:

stdenv.mkDerivation rec {
  name = "usb-modeswitch-2.2.0";

  src =fetchurl {
    url = "http://www.draisberghof.de/usb_modeswitch/${name}.tar.bz2";
    sha256 = "0flaj3mq0xhzk72kkpclwglf77kcw5rkwvkaimn5zvbiw4yi0li7";
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
