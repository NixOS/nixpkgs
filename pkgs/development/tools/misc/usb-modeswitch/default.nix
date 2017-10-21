{ stdenv, fetchurl, pkgconfig, libusb1 }:

stdenv.mkDerivation rec {
  name = "usb-modeswitch-${version}";
  version = "2.5.0";

  src = fetchurl {
    url    = "http://www.draisberghof.de/usb_modeswitch/${name}.tar.bz2";
    sha256 = "0cvnd16n2sp3w46fy507nl29q39jxxdk5qqbvk1rxaa91llbxh1i";
  };

  makeFlags = [
    "DESTDIR=$(out)"
    "PREFIX=$(out)"
  ];

  # make clean: we always build from source. It should be necessary on x86_64 only
  preConfigure = ''
    find -type f | xargs sed 's@/bin/rm@rm@g' -i
    make clean
  '';

  buildInputs = [ libusb1 ];
  nativeBuildInputs = [ pkgconfig ];

  meta = with stdenv.lib; {
    description = "A mode switching tool for controlling 'multi-mode' USB devices";
    license = licenses.gpl2;
    maintainers = with maintainers; [ marcweber peterhoeg ];
    platforms = platforms.linux;
  };
}
