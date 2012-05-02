{ stdenv, fetchurl }:

stdenv.mkDerivation {
  name = "memtest86+-4.20";
  
  src = fetchurl {
    url = http://www.memtest.org/download/4.20/memtest86+-4.20.tar.gz;
    sha256 = "0dw7kvfxiwqdmhapbz6ds1j9fralbky56hnzj4c6fsqfinbwwc2n";
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
    homepage = http://www.memtest.org/;
    description = "A tool to detect memory errors, fork from memtest86";
  };
}
