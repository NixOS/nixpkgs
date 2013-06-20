{ stdenv
, fetchurl
, autoconf
, automake
, libtool
, xorgserver, xproto, fontsproto, xf86driproto, renderproto, videoproto, pixman
, utilmacros
, libdrm
, pkgconfig }:

stdenv.mkDerivation rec {
  name = "xf86-video-nouveau-1.0.7";

  src = fetchurl {
    url = "mirror://xorg/individual/driver/${name}.tar.bz2";
    sha256 = "0cg1q9dz9ksfp593x707gr10s8p7z00zdws1r4lshg42w5ccd1yi";
  };


  buildInputs = [
    xorgserver xproto fontsproto xf86driproto renderproto videoproto pixman
    utilmacros
    libdrm
    pkgconfig
  ];


  meta = {
    homepage = http://nouveau.freedesktop.org/wiki/;

    description = "The xorg driver for nouveau-driven video cards";

    license = "gplv2";

    maintainers = [ stdenv.lib.maintainers.shlevy ];
  };
}
