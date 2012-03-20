{
  stdenv
, fetchurl
, autoconf
, automake
, utilmacros
, pkgconfig
, libtool
, mtdev
, xorgserver
, xproto
, inputproto
}:

stdenv.mkDerivation {
  name = "xf86-input-mtrack-0.2.0";

  preConfigure = "autoreconf -vfi";

  buildInputs = [
    autoconf
    automake
    utilmacros
    pkgconfig
    libtool
    mtdev
    xorgserver
    xproto
    inputproto
  ];

  src = fetchurl {
    name = "xf86-input-mtrack.tar.gz";
    url = "https://github.com/BlueDragonX/xf86-input-mtrack/tarball/v0.2.0";
    sha256 = "1zvd68dxpjn44ys7ysi3yc95xdjw1rz0s3xwlh3fzpw1ib3wrr3x";
  };

  meta = {
    homepage = https://github.com/BlueDragonX/xf86-input-mtrack;

    description = "An Xorg driver for multitouch trackpads";

    license = "gplv2";

    maintainers = [ stdenv.lib.maintainers.shlevy ];
  };
}
