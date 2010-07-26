{stdenv, fetchurl, x11, mesa}:

stdenv.mkDerivation {
  name = "glxinfo-7.8.2";
  
  src = fetchurl {
    url = ftp://ftp.freedesktop.org/pub/mesa/7.8.2/MesaDemos-7.8.2.tar.bz2;
    md5 = "757d9e2e06f48b1a52848be9b0307ced";
  };

  buildInputs = [x11 mesa];

  buildPhase = "
    cd progs/xdemos
    gcc glxinfo.c -o glxinfo -lGL -lX11 
    gcc glxgears.c -o glxgears -lGL -lX11
  ";

  installPhase = "
    ensureDir $out/bin
    cp glxinfo glxgears $out/bin
  ";
}
