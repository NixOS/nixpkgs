{ stdenv, fetchurl, cmake, mesa, libX11, libXv, libjpeg_turbo, fltk }:

stdenv.mkDerivation rec {
  name = "virtualgl-lib-${version}";
  version = "2.5";

  src = fetchurl {
    url = "mirror://sourceforge/virtualgl/VirtualGL-${version}.tar.gz";
    sha256 = "1mnpljmx8nxnmpbx4ja430b3y535wkz185qknsxmk27yz4dbmm8l";
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
