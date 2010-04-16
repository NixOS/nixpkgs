args: with args;

stdenv.mkDerivation {

  name = "usb-modeswitch-1.1.1";

  src = /tmp/marc/usb-modeswitch-1.1.1.tar.bz2;
    /*
    fetchurl {
    url = 
    sha256 = "0f7da588yvb1d3l3gk5m0hrqlhg8m4gw93aip3dwkmnawz9r0qca";
  };
  */

  # make clean: we always build from source. It should be necessary on x86_64 only
  preConfigure = ''
    find -type f | xargs sed 's@/bin/rm@rm@g' -i
    make clean
    ensureDir $out/{etc,lib/udev,share/man/man1}
    makeFlags="DESTDIR=$out PREFIX=$out"
  '';

  buildInputs = [libusb];

  meta = {
    description = "...";
    homepage = "TODO";
    license = "GPLv2";
    maintainers = [stdenv.lib.maintainers.marcweber];
    platforms = stdenv.lib.platforms.linux;
  };
}
