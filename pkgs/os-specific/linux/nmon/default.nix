{ fetchurl, lib, stdenv, ncurses }:

stdenv.mkDerivation rec {
  pname = "nmon";
<<<<<<< HEAD
  version = "16p";

  src = fetchurl {
    url = "mirror://sourceforge/nmon/lmon${version}.c";
    sha256 = "sha256-XcYEX2cl4ySalpkY+uaWY6HWaRYgh3ILq825D86eayo=";
=======
  version = "16n";

  src = fetchurl {
    url = "mirror://sourceforge/nmon/lmon${version}.c";
    sha256 = "1wpm2f30414b87kpbr9hbidblr5cmfby5skwqd0fkpi5v712q0f0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  buildInputs = [ ncurses ];
  dontUnpack = true;
  buildPhase = "${stdenv.cc.targetPrefix}cc -o nmon ${src} -g -O2 -D JFS -D GETUSER -Wall -D LARGEMEM -lncurses -lm -g -D ${
    with stdenv.targetPlatform;
    if isx86 then "X86"
    else if isAarch then "ARM"
    else if isPower then "POWER"
    else "UNKNOWN"
  }";
  installPhase = ''
    mkdir -p $out/bin
    cp nmon $out/bin
  '';

  meta = with lib; {
    description = "AIX & Linux Performance Monitoring tool";
    homepage = "https://nmon.sourceforge.net";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ sveitser ];
  };
}
