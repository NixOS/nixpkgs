{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "memtest86+-1.70";
  
  src = fetchurl {
    url = http://www.memtest.org/download/1.70/memtest86+-1.70.tar.gz;
    sha256 = "1swj4hc764qwb3j80kvvb4qg5maq9dp8pxzy9jkk187jf92j8vfw";
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
    ensureDir $out
    cp memtest.bin $out/
  '';
}
