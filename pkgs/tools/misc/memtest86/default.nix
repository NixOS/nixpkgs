{ stdenv, fetchurl }:

stdenv.mkDerivation {
  name = "memtest86+-4.10";
  
  src = fetchurl {
    url = http://www.memtest.org/download/4.10/memtest86+-4.10.tar.gz;
    sha256 = "0kxa2m7vfcm543wp53fv16sjjf5p12mzdz5rm87mrrr6hw43a6gq";
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
