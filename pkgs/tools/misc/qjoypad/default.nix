{ stdenv, fetchurl, pkgconfig, libX11, libXtst, qt4 }:
stdenv.mkDerivation rec {
  name = "qjoypad-4.1.0";
  src = fetchurl {
    url = "mirror://sourceforge/qjoypad/${name}.tar.gz";
    sha256 = "1jlm7i26nfp185xrl41kz5z6fgvyj51bjpz48cg27xx64y40iamm";
  };
  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libX11 libXtst qt4 ];
  NIX_LDFLAGS = [ "-lX11" ];
  patchPhase = ''
    cd src
    substituteInPlace config --replace /bin/bash /bin/sh
    mkdir -p $out
    export NIX_LDFLAGS="$NIX_LDFLAGS -rpath ${libX11}/lib"
  '';
  meta = {
    description = "A program that lets you use gaming devices anywhere";
    longDescription = ''
      A simple Linux/QT program that lets you use your gaming devices
      where you want them: in your games! QJoyPad takes input from a
      gamepad or joystick and translates it into key strokes or mouse
      actions, letting you control any XWindows program with your game
      controller. This lets you play all those games that for some
      reason don't have joystick support with your joystick. QJoyPad
      also gives you the advantage of multiple saved layouts so you
      can have a separate setting for every game, or for every class
      of game! That way you can play your games the way you want, not
      the way the programmers decided, and you can have the same
      button be "fire" in every one of your space fighters. QJoyPad
      gives you the freedom and flexibility to really take advantage
      of gaming devices in Linux, and makes the Linux gaming
      experience just a little bit nicer.
    '';
    homepage = http://qjoypad.sourceforge.net;
    license = stdenv.lib.licenses.gpl2;
    maintainers = with stdenv.lib.maintainers; [ astsmtl ];
    platforms = with stdenv.lib.platforms; linux;
  };
}
