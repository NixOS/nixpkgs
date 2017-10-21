{ stdenv, fetchurl, cmake, mesa, libX11, libXv, libjpeg_turbo, fltk }:

stdenv.mkDerivation rec {
  name = "virtualgl-lib-${version}";
  version = "2.5.2";

  src = fetchurl {
    url = "mirror://sourceforge/virtualgl/VirtualGL-${version}.tar.gz";
    sha256 = "0f1jp7r4vajiksbiq08hkxd5bjj0jxlw7dy5750s52djg1v3hhsg";
  };

  cmakeFlags = [ "-DVGL_SYSTEMFLTK=1" "-DTJPEG_LIBRARY=${libjpeg_turbo.out}/lib/libturbojpeg.so" ];

  makeFlags = [ "PREFIX=$(out)" ];

  nativeBuildInputs = [ cmake ];

  buildInputs = [ libjpeg_turbo mesa fltk libX11 libXv ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = http://www.virtualgl.org/;
    description = "X11 GL rendering in a remote computer with full 3D hw acceleration";
    license = licenses.free; # many parts under different free licenses
    platforms = platforms.linux;
    maintainers = with maintainers; [ abbradar ];
  };
}
