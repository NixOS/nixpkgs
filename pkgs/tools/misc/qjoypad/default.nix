{ lib, mkDerivation, fetchFromGitHub, cmake, pkgconfig, libX11, libXtst, qtbase, qttools, qtx11extras }:

mkDerivation rec {
  pname = "qjoypad";
  version = "4.3.0";

  src = fetchFromGitHub {
    owner = "panzi";
    repo = "qjoypad";
    rev = "v${version}";
    sha256 = "0ps85ncqmy8jz3zzyv5f5z4564kkgcl799ri4kcz407mjyc4fvs6";
  };

  nativeBuildInputs = [ pkgconfig cmake ];
  buildInputs = [ libX11 libXtst qtbase qttools qtx11extras ];
  NIX_LDFLAGS = [ "-lX11" ];
  meta = with lib; {
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
    homepage = "https://github.com/panzi/qjoypad";
    license = licenses.gpl2;
    maintainers = with maintainers; [ astsmtl ];
    platforms = with platforms; linux;
  };
}
