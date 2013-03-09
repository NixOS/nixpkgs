{ stdenv, fetchurl, mesa, libX11, openssl, libXext
, libjpeg_turbo, cmake }:

let
  version = "2.3.2";
in
stdenv.mkDerivation {
  name = "virtualgl-${version}";
  src = fetchurl {
    url = "mirror://sourceforge/virtualgl/VirtualGL-${version}.tar.gz";
    sha256 = "062lrhd8yr13ch4wpgzxdabqs92j4q7fcl3a0c3sdlav4arspqmy";
  };

  patches = [ ./xshm.patch ./fixturbopath.patch ];

  prePatch = ''
    sed -i s,LD_PRELOAD=lib,LD_PRELOAD=$out/lib/lib, server/vglrun
  '';

  cmakeFlags = [ "-DTJPEG_LIBRARY=${libjpeg_turbo}/lib/libturbojpeg.so" ];

  preInstall = ''
    export makeFlags="prefix=$out"
  '';

  buildInputs = [ cmake mesa libX11 openssl libXext libjpeg_turbo ];

  meta = {
    homepage = http://www.virtualgl.org/;
    description = "X11 GL rendering in a remote computer with full 3D hw acceleration";
    license = "free"; # many parts under different free licenses
  };
}
