{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "memtest86+-2.11";
  
  src = fetchurl {
    url = http://www.memtest.org/download/2.11/memtest86+-2.11.tar.gz;
    sha256 = "03kcw6f62na3s08ybhnafn4s1pqs0z5lxl103xwxx77345r6m1s3";
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

  meta = {
    homepage = http://www.memtest.org/;
    description = "A tool to detect memory errors";
  };
}
