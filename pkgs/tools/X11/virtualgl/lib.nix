{ stdenv, fetchurl, cmake, libGL, libGLU, libX11, libXv, libXtst, libjpeg_turbo, fltk }:

stdenv.mkDerivation rec {
  pname = "virtualgl-lib";
  version = "2.6.2";

  src = fetchurl {
    url = "mirror://sourceforge/virtualgl/VirtualGL-${version}.tar.gz";
    sha256 = "0ngqwsm9bml6lis0igq3bn92amh04rccd6jhjibj3418hrbzipvr";
  };

  cmakeFlags = [ "-DVGL_SYSTEMFLTK=1" "-DTJPEG_LIBRARY=${libjpeg_turbo.out}/lib/libturbojpeg.so" ];

  makeFlags = [ "PREFIX=$(out)" ];

  nativeBuildInputs = [ cmake ];

  buildInputs = [ libjpeg_turbo libGL libGLU fltk libX11 libXv libXtst ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = "http://www.virtualgl.org/";
    description = "X11 GL rendering in a remote computer with full 3D hw acceleration";
    license = licenses.wxWindows;
    platforms = platforms.linux;
    maintainers = with maintainers; [ abbradar ];
  };
}
