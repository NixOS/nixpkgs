{ stdenv, fetchurl, cmake, mesa, libX11, libXv, libjpeg_turbo, fltk }:

let
  version = "2.4.1";
in
stdenv.mkDerivation {
  name = "virtualgl-lib-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/virtualgl/VirtualGL-${version}.tar.gz";
    sha256 = "0bngb4hrl0kn19qb3sa6mg6dbaahfk09gx2ng18l00xm6pmwd298";
  };

  cmakeFlags = [ "-DVGL_SYSTEMFLTK=1" "-DTJPEG_LIBRARY=${libjpeg_turbo}/lib/libturbojpeg.so" ];

  makeFlags = [ "PREFIX=$(out)" ];

  nativeBuildInputs = [ cmake ];

  buildInputs = [ libjpeg_turbo mesa fltk libX11 libXv ];

  meta = with stdenv.lib; {
    homepage = http://www.virtualgl.org/;
    description = "X11 GL rendering in a remote computer with full 3D hw acceleration";
    license = licenses.free; # many parts under different free licenses
    platforms = platforms.linux;
    maintainers = with maintainers; [ abbradar ];
  };
}
