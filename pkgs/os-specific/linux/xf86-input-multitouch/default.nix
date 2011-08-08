{ stdenv
, fetchgit
, mtdev
, xorgserver
, xproto
, pixman
, xextproto
, inputproto
, randrproto
, libpciaccess
}:

stdenv.mkDerivation {
  name = "xf86-input-multitouch-20110312";

  src = fetchgit {
    url = http://bitmath.org/git/multitouch.git;
    rev = "4d87c041f6a232aa30528d70d4b9946d1824b4ed";
    sha256 = "de705e34bc75654139dfcbedfe43a3d182d140b198fcd57ab190d549471305ca";
  };

  confFile = ''
    Section "InputClass"
        MatchIsTouchpad "true"
        Identifier "Multitouch Touchpad"
        Driver "multitouch"
    EndSection
  '';

  buildInputs = [ mtdev xproto xextproto inputproto libpciaccess randrproto ];

  buildPhase = ''
    make INCLUDE="$NIX_CFLAGS_COMPILE -I${xorgserver}/include/xorg -I${pixman}/include/pixman-1 -Iinclude"
  '';

  installPhase = ''
    make DESTDIR="$out" LIBDIR="lib" install
    ensureDir $out/include/xorg
    echo -n "$confFile" > $out/include/xorg/10-multitouch.conf
  '';
}
