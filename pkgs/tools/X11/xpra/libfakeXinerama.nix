{ lib, stdenv, fetchurl, libX11, libXinerama }:

stdenv.mkDerivation  rec {
  pname = "libfakeXinerama";
  version = "0.1.0";

  src = fetchurl {
    url = "https://www.xpra.org/src/${pname}-${version}.tar.bz2";
    sha256 = "0gxb8jska2anbb3c1m8asbglgnwylgdr44x9lr8yh91hjxsqadkx";
  };

  buildInputs = [ libX11 libXinerama ];

  buildPhase = ''
    gcc -O2 -Wall fakeXinerama.c -fPIC -o libfakeXinerama.so.1.0 -shared
  '';

  installPhase = ''
    mkdir -p $out/lib
    cp libfakeXinerama.so.1.0 $out/lib
    ln -s libfakeXinerama.so.1.0 $out/lib/libXinerama.so.1.0
    ln -s libXinerama.so.1.0 $out/lib/libXinerama.so.1
    ln -s libXinerama.so.1 $out/lib/libXinerama.so
  '';

  meta = with lib; {
    homepage = "http://xpra.org/";
    description = "fakeXinerama for Xpra";
    platforms = platforms.linux;
    maintainers = [ ];
    license = licenses.gpl2;
  };
}
