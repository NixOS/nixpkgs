{ stdenv, fetchgit, autoreconfHook, xorgproto, libX11, libXext
, pixman, pkgconfig, utilmacros, xorgserver
}:

stdenv.mkDerivation {
  name = "xf86-video-nested-2012-06-15";

  src = fetchgit {
    url = git://anongit.freedesktop.org/xorg/driver/xf86-video-nested;
    rev = "ad48dc6eb98776a8a886f26f31c0110352fa1da4";
    sha256 = "0r5k9rk8mq4j51a310qvvfmhhz8a0cmcwr8pl8mkwfsgcpwxbpfg";
  };

  buildInputs =
    [ autoreconfHook xorgproto libX11 libXext pixman
      pkgconfig utilmacros xorgserver
    ];

  hardeningDisable = [ "fortify" ];

  CFLAGS = "-I${pixman}/include/pixman-1";

  meta = {
    homepage = https://cgit.freedesktop.org/xorg/driver/xf86-video-nested;
    description = "A driver to run Xorg on top of Xorg or something else";
    maintainers = [ stdenv.lib.maintainers.goibhniu ];
    platforms = stdenv.lib.platforms.linux;
  };
}
