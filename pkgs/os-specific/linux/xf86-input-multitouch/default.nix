{ stdenv
, fetchgit
, mtdev
, pixman
, xorg
, libpciaccess
}:

stdenv.mkDerivation {
  name = "xf86-input-multitouch-20110312";

  src = fetchgit {
    url = http://bitmath.org/git/multitouch.git;
    rev = "4d87c041f6a232aa30528d70d4b9946d1824b4ed";
    sha256 = "1jh52d3lkmchn5xdbz4qn50d30nild1zxvfbvwwl2rbmphs5ww6y";
  };

  # Configuration from http://bitmath.org/code/multitouch/
  confFile = ''
    Section "InputClass"
        MatchIsTouchpad "true"
        Identifier "Multitouch Touchpad"
        Driver "multitouch"
    EndSection
  '';

  buildInputs = with xorg; [
    mtdev xorgproto libpciaccess libxcb
  ];

  buildPhase = ''
    make INCLUDE="$NIX_CFLAGS_COMPILE -I${xorg.xorgserver.dev}/include/xorg -I${pixman}/include/pixman-1 -Iinclude"
  '';

  installPhase = ''
    make DESTDIR="$out" LIBDIR="lib" install
    mkdir -p $out/include/xorg
    echo -n "$confFile" > $out/include/xorg/10-multitouch.conf
  '';

  meta = {
    homepage = http://bitmath.org/code/multitouch/;

    description = "Brings multitouch gestures to the Linux desktop";

    license = stdenv.lib.licenses.gpl2;
  };
}
