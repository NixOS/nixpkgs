{ stdenv, fetchurl }:

stdenv.mkDerivation {
  name = "memtest86-4.3.6";
  
  src = fetchurl {
    url = http://www.memtest86.com/downloads/memtest86-4.3.6-src.tar.gz;
    sha256 = "0qbksyl2hmkm12n7zbmf2m2n3q811skhykxx6a9a7y6r7k8y5qmv";
  };

  preBuild = ''
    # Really dirty hack to get Memtest to build without needing a Glibc
    # with 32-bit libraries and headers.
    if test "$system" = x86_64-linux; then
        mkdir gnu
        touch gnu/stubs-32.h
    fi
  '';

  NIX_CFLAGS_COMPILE = "-I.";
  
  installPhase = ''
    mkdir -p $out
    cp memtest.bin $out/
  '';

  meta = {
    homepage = http://memtest86.com/;
    description = "A tool to detect memory errors, to be run from a bootloader";
    broken = true;
  };
}
