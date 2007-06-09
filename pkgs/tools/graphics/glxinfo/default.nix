{stdenv, fetchurl, x11, mesa, libXext}:

stdenv.mkDerivation {
  name = "glxinfo-6.5.2";
  
  src = fetchurl {
    url = http://heanet.dl.sourceforge.net/sourceforge/mesa3d/MesaDemos-6.5.2.tar.bz2;
    sha256 = "1shfwy0sy3kdk3nykp1gv6s0lafqgqnadwarw5cbpw7mkfap8kw0";
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

  postFixup = "
    for i in $out/bin/*; do
      patchelf --set-rpath /var/run/opengl-driver/lib:${libXext}/lib:$(patchelf --print-rpath $i) $i
    done
  ";
}
