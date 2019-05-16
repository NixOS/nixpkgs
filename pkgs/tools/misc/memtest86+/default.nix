{ stdenv, fetchgit }:

stdenv.mkDerivation rec {
  name = "memtest86+-5.01+coreboot-20180113";

  src = fetchgit {
    url = "https://review.coreboot.org/memtest86plus";
    rev = "5ca4eb9544e51254254d09ae6e70f93403469ec3";
    sha256 = "08m4rjr0chhhb1whgggknz926zv9hm8bisnxqp8lffqiwhb55rgk";
  };

  preBuild = ''
    # Really dirty hack to get Memtest to build without needing a Glibc
    # with 32-bit libraries and headers.
    if test "$system" = x86_64-linux; then
        mkdir gnu
        touch gnu/stubs-32.h
    fi
  '';

  NIX_CFLAGS_COMPILE = "-I. -std=gnu90";

  hardeningDisable = [ "all" ];

  buildFlags = "memtest.bin";

  doCheck = false; # fails

  installPhase = ''
    mkdir -p $out
    chmod -x memtest.bin
    cp memtest.bin $out/
  '';

  meta = {
    homepage = http://www.memtest.org/;
    description = "A tool to detect memory errors";
    license = stdenv.lib.licenses.gpl2;
    platforms = [ "x86_64-linux" "i686-linux" ];
  };
}
