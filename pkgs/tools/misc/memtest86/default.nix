{ stdenv, fetchurl }:

stdenv.mkDerivation {
  name = "memtest86-4.3.3";
  
  src = fetchurl {
    url = http://www.memtest86.com/downloads/memtest86-4.3.3-src.tar.gz;
    sha256 = "1fzpk0s97lx8h1wbv2bgr6m8v4ag8i58kzr8fa25bvwyl8hks9sl";
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
