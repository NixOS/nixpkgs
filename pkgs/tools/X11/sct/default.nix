{stdenv, fetchgit, libX11, libXrandr}:
stdenv.mkDerivation rec {
  name = "sct";
  buildInputs = [libX11 libXrandr];
  src = fetchgit {
    url = git://github.com/wmapp/sct.git;
    rev = "be00d189f491b9100233b3a623b026bbffccb18e";
    sha256 = "1bivy0sl5v1jsq4jbq6p9hplz6cvw4nx9rc96p2kxsg506rqllc5";
    
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
