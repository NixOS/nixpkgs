{ stdenv, fetchgit, autoreconfHook, xorgproto, libX11, libXext
, pixman, pkgconfig, utilmacros, xorgserver
}:

stdenv.mkDerivation {
  name = "xf86-video-nested-2017-06-12";

  src = fetchgit {
    url = git://anongit.freedesktop.org/xorg/driver/xf86-video-nested;
    rev = "6a48b385c41ea89354d0b2ee7f4649a1d1d9ec70";
    sha256 = "133rd2kvr2q2wmwpx82bb93qbi8wm8qp1vlmbhgc7aslz0j4cqqv";
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
