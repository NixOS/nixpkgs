{ stdenv, sources }:

stdenv.mkDerivation {
  pname = "murmur3";
  version = sources.murmur3.rev;
  src = sources.murmur3;

  buildPhase = ''
    $CC -fPIC -O3 -o murmur3.o -c $src/murmur3.c
  '';

  installPhase = ''
    mkdir -p $out/{lib,include}
    $AR rcs $out/lib/libmurmur3.a murmur3.o
    cp $src/*.h $out/include/
  '';
}
