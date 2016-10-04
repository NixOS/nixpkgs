{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "gnumake-3.80";

  src = fetchurl {
    url = http://tarballs.nixos.org/make-3.80.tar.bz2;
    sha256 = "06rgz6npynr8whmf7rxgkyvcz0clf3ggwf4cyhj3fcscn3kkk6x9";
  };

  patches = [./log.patch];

  hardeningDisable = [ "format" ];

  meta = {
    platforms = stdenv.lib.platforms.unix;
  };
}
