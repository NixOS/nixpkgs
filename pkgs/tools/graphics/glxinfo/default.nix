{stdenv, fetchurl, x11, mesa}:

stdenv.mkDerivation {
  name = "glxinfo-7.4.1";
  
  src = fetchurl {
    url = mirror://sourceforge/mesa3d/MesaDemos-7.4.1.tar.bz2;
    md5 = "1e169fb6abc2b45613f1c98a82dfe690";
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
