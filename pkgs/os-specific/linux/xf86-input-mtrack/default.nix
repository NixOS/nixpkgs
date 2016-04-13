{
  stdenv
, fetchurl
, utilmacros
, pkgconfig
, mtdev
, xorgserver
, xproto
, inputproto
, pixman
, autoreconfHook
}:

stdenv.mkDerivation {
  name = "xf86-input-mtrack-0.3.0";

  buildInputs = [
    utilmacros
    pkgconfig
    mtdev
    xorgserver
    xproto
    inputproto
    pixman
    autoreconfHook
  ];

  CFLAGS = "-I${pixman}/include/pixman-1";

  src = fetchurl {
    name = "xf86-input-mtrack.tar.gz";
    url = "https://github.com/BlueDragonX/xf86-input-mtrack/tarball/v0.3.0";
    sha256 = "174rdw7gv0wsnjgmwpx4pgjn1zfbylflda4k2dzff6phzxj9yl6v";
  };

  meta = {
    homepage = https://github.com/BlueDragonX/xf86-input-mtrack;

    description = "An Xorg driver for multitouch trackpads";

    license = stdenv.lib.licenses.gpl2;
  };
}
