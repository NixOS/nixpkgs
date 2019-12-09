{ stdenv, fetchurl, pkgconfig, libusb1 }:

stdenv.mkDerivation rec {
  pname = "usb-modeswitch";
  version = "2.6.0";

  src = fetchurl {
    url    = "http://www.draisberghof.de/usb_modeswitch/${pname}-${version}.tar.bz2";
    sha256 = "18wbbxc5cfsmikba0msdvd5qlaga27b32nhrzicyd9mdddp265f2";
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
