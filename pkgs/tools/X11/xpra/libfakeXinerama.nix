{ stdenv, fetchurl, libX11, libXinerama }:

stdenv.mkDerivation  rec {
  name = "libfakeXinerama-${version}";
  version = "0.1.0";

  src = fetchurl {
    url = "https://www.xpra.org/src/${name}.tar.bz2";
    sha256 = "0gxb8jska2anbb3c1m8asbglgnwylgdr44x9lr8yh91hjxsqadkx";
  };

  buildInputs = [ libX11 libXinerama ];

  phases = [ "unpackPhase" "buildPhase" "installPhase" ];

  buildPhase = ''
    gcc -O2 -Wall fakeXinerama.c -fPIC -o libfakeXinerama.so.1.0 -shared
  '';

  installPhase = ''
    mkdir -p $out/lib
    cp libfakeXinerama.so.1.0 $out/lib
    ln -s libXinerama.so.1.0 $out/lib/libXinerama.so.1
    ln -s libXinerama.so.1 $out/lib/libXinerama.so
  '';

  meta = with stdenv.lib; {
    homepage = http://xpra.org/;
    description = "fakeXinerama for Xpra";
    platforms = platforms.linux;
    maintainers = [ maintainers.tstrobel ];
    license = licenses.gpl2;
  };
}
