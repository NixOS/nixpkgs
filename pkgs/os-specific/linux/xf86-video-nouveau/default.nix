{ stdenv
, fetchgit
, autoconf
, automake
, libtool
, xorgserver, xproto, fontsproto, xf86driproto, renderproto, videoproto
, utilmacros
, libdrm
, pkgconfig }:

stdenv.mkDerivation {
  name = "xf86-video-nouveau-2012-03-05";

  src = fetchgit {
    url = git://anongit.freedesktop.org/nouveau/xf86-video-nouveau;
    rev = "f5d1cd2cb6808838ae1a188cef888eaa9582c76d";
    sha256 = "8c20e9ce7897fbd4c5097e4738e80ecca30e6326b758a13fc97f96ccc12fd7d9"; 
  };

  buildInputs = [
    autoconf
    automake
    libtool
    xorgserver xproto fontsproto xf86driproto renderproto videoproto
    utilmacros
    libdrm
    pkgconfig
  ];

  preConfigure = "autoreconf -vfi";

  meta = {
    homepage = http://nouveau.freedesktop.org/wiki/;

    description = "The xorg driver for nouveau-driven video cards";

    license = "gplv2";

    maintainers = [ stdenv.lib.maintainers.shlevy ];
  };
}
