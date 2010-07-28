{ stdenv, fetchurl, libusb }:

stdenv.mkDerivation {
  name = "usb-modeswitch-1.1.2";

  src =fetchurl {
    url = "http://www.draisberghof.de/usb_modeswitch/usb-modeswitch-1.1.2.tar.bz2";
    sha256 = "1wzhd0r49nh5y43qrvsi3c7a29206zwd6v8xlpb8dqm40xg3j9nz";
  };

  # make clean: we always build from source. It should be necessary on x86_64 only
  preConfigure = ''
    find -type f | xargs sed 's@/bin/rm@rm@g' -i
    make clean
    ensureDir $out/{etc,lib/udev,share/man/man1}
    makeFlags="DESTDIR=$out PREFIX=$out"
  '';

  buildInputs = [ libusb ];

  meta = {
    license = "GPLv2";
    maintainers = [ stdenv.lib.maintainers.marcweber ];
    platforms = stdenv.lib.platforms.linux;
  };
}
