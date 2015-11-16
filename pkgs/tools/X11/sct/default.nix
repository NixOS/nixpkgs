{stdenv, fetchurl, libX11, libXrandr}:
stdenv.mkDerivation rec {
  name = "sct";
  buildInputs = [libX11 libXrandr];
  src = fetchurl {
    url = http://www.tedunangst.com/flak/files/sct.c;
    sha256 = "1bivy0sl5v1jsq4jbq6p9hplz6cvw4nx9rc96p2kxsg506rqllc5";
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
