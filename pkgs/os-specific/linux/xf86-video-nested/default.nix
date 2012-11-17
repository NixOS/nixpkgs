{ stdenv, fetchgit, autoconf, automake, fontsproto, libX11, libXext
, libtool, pixman, pkgconfig, renderproto, utilmacros, xorgserver
}:

stdenv.mkDerivation {
  name = "xf86-video-nested-2012-06-15";

  src = fetchgit {
    url = git://anongit.freedesktop.org/xorg/driver/xf86-video-nested;
    rev = "ad48dc6eb98776a8a886f26f31c0110352fa1da4";
    sha256 = "43a102405acdcdb346ab197b33c8fa724d2140f33754f8ee3941a0eea152735c";
  };

  buildInputs =
    [ autoconf automake fontsproto libX11 libXext libtool pixman
      pkgconfig renderproto utilmacros xorgserver
    ];


  configurePhase = ''
    autoreconf -fvi
    ./configure --prefix=$out CFLAGS="-I${pixman}/include/pixman-1"
  '';

  meta = {
    homepage = git://anongit.freedesktop.org/xorg/driver/xf86-video-nested;
    description = "Driver to run Xorg on top of Xorg or something else";
    maintainers = [ stdenv.lib.maintainers.goibhniu ];
    platforms = stdenv.lib.platforms.linux;
  };
}
