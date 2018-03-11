{ stdenv, fetchurl, xlibsWrapper, libGL }:

let version = "8.3.0"; in

stdenv.mkDerivation {
  name = "glxinfo-${version}";

  src = fetchurl {
    url = "ftp://ftp.freedesktop.org/pub/libGLU_combined/demos/${version}/mesa-demos-${version}.tar.bz2";
    sha256 = "1vqb7s5m3fcg2csbiz45mha1pys2xx6rhw94fcyvapqdpm5iawy1";
  };

  buildInputs = [ xlibsWrapper libGL ];

  configurePhase = "true";

  buildPhase = "
    cd src/xdemos
    gcc glxinfo.c glinfo_common.c -o glxinfo -lGL -lX11
    gcc glxgears.c -o glxgears -lGL -lX11
  ";

  installPhase = "
    mkdir -p $out/bin
    cp glxinfo glxgears $out/bin/
  ";

  meta = {
    platforms = stdenv.lib.platforms.linux;
  };
}
