{ stdenv, fetchurl }:

stdenv.mkDerivation {
  name = "memtest86-4.0a";
  
  src = fetchurl {
    url = http://memtest86.com/memtest86-4.0a.tar.gz;
    sha256 = "0d2n3nzyvna9k880zk6vl1z3b7wal1hrwcqay9vda8br7yp7634y";
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
  };
}
