{stdenv, fetchurl, x11, mesa}:

stdenv.mkDerivation {
  name = "glxinfo-7.2";
  
  src = fetchurl {
    url = mirror://sourceforge/mesa3d/MesaDemos-7.2.tar.bz2;
    md5 = "22e03dc4038cd63f32c21eb60994892b";
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
