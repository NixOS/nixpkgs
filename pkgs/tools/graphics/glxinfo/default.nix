{ stdenv, fetchurl, libGL, libX11 }:

stdenv.mkDerivation rec {
  name = "glxinfo-${version}";
  version = "8.3.0";

  src = fetchurl {
    url = "ftp://ftp.freedesktop.org/pub/mesa/demos/${version}/mesa-demos-${version}.tar.bz2";
    sha256 = "1vqb7s5m3fcg2csbiz45mha1pys2xx6rhw94fcyvapqdpm5iawy1";
  };

  buildInputs = [ libX11 libGL ];

  configurePhase = "true";

  buildPhase = "
    cd src/xdemos
    $CC glxinfo.c glinfo_common.c -o glxinfo -lGL -lX11
    $CC glxgears.c -o glxgears -lGL -lX11 -lm
  ";

  installPhase = "
    mkdir -p $out/bin
    cp glxinfo glxgears $out/bin/
  ";

  meta = with stdenv.lib; {
    description = "Test utilities for OpenGL";
    homepage = https://www.mesa3d.org/;
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ abbradar ];
  };
}
