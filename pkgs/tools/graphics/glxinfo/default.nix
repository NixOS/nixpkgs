{ lib, stdenv, fetchurl, libGL, libX11 }:

stdenv.mkDerivation rec {
  pname = "glxinfo";
  version = "8.4.0";

  src = fetchurl {
    url =
      "ftp://ftp.freedesktop.org/pub/mesa/demos/mesa-demos-${version}.tar.bz2";
    sha256 = "0zgzbz55a14hz83gbmm0n9gpjnf5zadzi2kjjvkn6khql2a9rs81";
  };

  buildInputs = [ libX11 libGL ];

  dontConfigure = true;

  buildPhase =
    "\n    $CC src/xdemos/{glxinfo.c,glinfo_common.c} -o glxinfo -lGL -lX11\n    $CC src/xdemos/glxgears.c -o glxgears -lGL -lX11 -lm\n    $CC src/egl/opengles2/es2_info.c -o es2_info -lEGL -lGLESv2 -lX11\n    $CC src/egl/opengles2/es2gears.c src/egl/eglut/{eglut.c,eglut_x11.c} -o es2gears -Isrc/egl/eglut -lEGL -lGLESv2 -lX11 -lm\n    $CC src/egl/opengl/eglinfo.c -o eglinfo -lEGL -lGLESv2 -lX11\n  ";

  installPhase =
    "\n    install -Dm 555 -t $out/bin glx{info,gears} es2{_info,gears} eglinfo\n  ";

  meta = with lib; {
    description = "Test utilities for OpenGL";
    homepage = "https://www.mesa3d.org/";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ abbradar ];
  };
}
