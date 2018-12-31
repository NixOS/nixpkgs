{ stdenv, lib, fetchurl
, xorgproto, xorgserver
, pkgconfig
, xpra }:

with lib;

stdenv.mkDerivation rec {
  version = "0.3.8";
  suffix = "1";
  name = "xpra-xf86videodummy-${version}-${suffix}";
  builder = ../../../../servers/x11/xorg/builder.sh;
  src = fetchurl {
    url = "mirror://xorg/individual/driver/xf86-video-dummy-${version}.tar.bz2";
    sha256 = "1fcm9vwgv8wnffbvkzddk4yxrh3kc0np6w65wj8k88q7jf3bn4ip";
  };
  patches = [
    ./0002-Constant-DPI.patch
    ./0003-fix-pointer-limits.patch
    ./0005-support-for-30-bit-depth-in-dummy-driver.patch
  ];
  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ xorgproto xorgserver ];

  meta = {
    description = "Dummy driver for Xorg with xpra patches";
    homepage = https://xpra.org/trac/wiki/Xdummy;
    license = licenses.gpl2;
    platforms = platforms.unix;
    maintainers = with maintainers; [ numinit ];
  };
}
