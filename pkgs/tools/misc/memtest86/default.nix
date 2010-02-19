{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "memtest86+-4.00";
  
  src = fetchurl {
    url = http://www.memtest.org/download/4.00/memtest86+-4.00.tar.gz;
    sha256 = "193chqvwmcxsrvpcfy3mbz1vakvpfhxvjmawzidp26x8kma2zi3f";
  };

  preBuild = ''
    # Really dirty hack to get Memtest to build without needing a Glibc
    # with 32-bit libraries and headers.
    if test "$system" = x86_64-linux; then
        mkdir gnu
        touch gnu/stubs-32.h
    fi
  '';

  # Override the default optimisation setting (`-Os') to prevent lots
  # of spurious errors.  See
  # https://bugs.launchpad.net/fedora/+source/memtest86+/+bug/246412.
  NIX_CFLAGS_COMPILE = "-O1 -I.";
  
  installPhase = ''
    ensureDir $out
    cp memtest.bin $out/
  '';

  meta = {
    homepage = http://www.memtest.org/;
    description = "A tool to detect memory errors";
  };
}
