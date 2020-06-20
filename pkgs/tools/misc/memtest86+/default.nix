{ stdenv, fetchgit }:

stdenv.mkDerivation {
  pname = "memtest86+";
  version = "5.01-coreboot-002";

  src = fetchgit {
    url = "https://review.coreboot.org/memtest86plus.git";
    rev = "v002";
    sha256 = "0cwx20yja24bfknqh1rjb5rl2c0kwnppzsisg1dibbak0l8mxchk";
  };

  NIX_CFLAGS_COMPILE = "-I. -std=gnu90";

  hardeningDisable = [ "all" ];

  buildFlags = [ "memtest.bin" ];

  doCheck = false; # fails

  installPhase = ''
    install -Dm0444 -t $out/ memtest.bin
  '';

  meta = {
    homepage = "http://www.memtest.org/";
    description = "A tool to detect memory errors";
    license = stdenv.lib.licenses.gpl2;
    platforms = [ "x86_64-linux" "i686-linux" ];
  };
}
