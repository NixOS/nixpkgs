{stdenv, fetchurl, libX11, libXrandr}:
stdenv.mkDerivation rec {
  name = "sct";
  buildInputs = [libX11 libXrandr];
  src = fetchurl {
    url = http://www.tedunangst.com/flak/files/sct.c;
    sha256 = "0dda697ec3f4129d793f8896743d82be09934883f5aeda05c4a2193d7ab3c305";
  };
  phases = ["patchPhase" "buildPhase" "installPhase"];
  patchPhase = ''
    sed -re "/Xlibint/d" ${src} > sct.c 
  '';
  buildPhase = "gcc -std=c99 sct.c -o sct -lX11 -lXrandr -lm";
  installPhase = ''
    mkdir -p "$out/bin"
    cp sct "$out/bin"
  '';
  meta = {
    description = ''A minimal utility to set display colour temperature'';
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = with stdenv.lib.platforms; linux ++ freebsd ++ openbsd;
  };
}
