{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "memtest86+-5.01";

  src = fetchurl {
    url = "http://www.memtest.org/download/5.01/${name}.tar.gz";
    sha256 = "0fch1l55753y6jkk0hj8f6vw4h1kinkn9ysp22dq5g9zjnvjf88l";
  };

  # Patch incompatiblity with GCC. Source: http://koji.fedoraproject.org/koji/buildinfo?buildID=586907
  patches = [ ./compile-fix.patch ./crash-fix.patch ./no-optimization.patch ];

  preBuild = ''
    # Really dirty hack to get Memtest to build without needing a Glibc
    # with 32-bit libraries and headers.
    if test "$system" = x86_64-linux; then
        mkdir gnu
        touch gnu/stubs-32.h
    fi
  '';

  NIX_CFLAGS_COMPILE = "-I. -std=gnu90";

  hardeningDisable = [ "stackprotector" "pic" ];

  buildFlags = "memtest.bin";

  installPhase = ''
    mkdir -p $out
    chmod -x memtest.bin
    cp memtest.bin $out/
  '';

  meta = {
    homepage = http://www.memtest.org/;
    description = "A tool to detect memory errors";
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.linux;
  };
}
