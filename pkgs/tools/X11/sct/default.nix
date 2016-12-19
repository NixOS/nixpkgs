{stdenv, fetchurl, libX11, libXrandr}:
stdenv.mkDerivation rec {
  name = "sct";
  buildInputs = [libX11 libXrandr];
  src = fetchurl {
    url = http://www.tedunangst.com/flak/files/sct.c;
    sha256 = "01f3ndx3s6d2qh2xmbpmhd4962dyh8yp95l87xwrs4plqdz6knhd";
    
    # Discussion regarding the checksum and the source code can be found in issue #17163 
    # The code seems unmaintained, yet an unknown (probably small change) in the code caused 
    # failed builds as the checksum had changed.
    # The checksum is updated for now, however, this is unpractical and potentially unsafe 
    # so any future changes might warrant a fork of the (feature complete) project. 
    # The code is under public domain.
    
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
