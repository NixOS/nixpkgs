{ stdenv, fetchurl, mesa, libX11, openssl, libXext
, libjpeg_turbo, cmake }:

let
  libDir = if stdenv.is64bit then "lib64" else "lib";
in
stdenv.mkDerivation {
  name = "virtualgl-2.1.4";
  src = fetchurl {
    url = mirror://sourceforge/virtualgl/VirtualGL-2.3.tar.gz;
    sha256 = "2f00c4eb20b0ae88e957a23fb66882e4ade2faa208abd30aa8c4f61570ecd4b9";
  };

  patches = [ ./xshm.patch ./fixturbopath.patch ];

  prePatch = ''
    sed -i s,LD_PRELOAD=lib,LD_PRELOAD=$out/${libDir}/lib, rr/vglrun
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
