{ fetchurl }:
[
  {
    name = "gmp-6.3.0.tar.xz";
    archive = fetchurl {
      sha256 = "1648ad1mr7c1r8lkkqshrv1jfjgfdb30plsadxhni7mq041bihm3";
      url = "mirror://gnu/gmp/gmp-6.3.0.tar.xz";
    };
  }
  {
    name = "mpfr-4.2.2.tar.xz";
    archive = fetchurl {
      sha256 = "00ffqs0sssb81bx007d0k2wc7hsyxy4yiqil6xbais7p7qwa0yxn";
      url = "mirror://gnu/mpfr/mpfr-4.2.2.tar.xz";
    };
  }
  {
    name = "mpc-1.3.1.tar.gz";
    archive = fetchurl {
      sha256 = "1f2rqz0hdrrhx4y1i5f8pv6yv08a876k1dqcm9s2p26gyn928r5b";
      url = "mirror://gnu/mpc/mpc-1.3.1.tar.gz";
    };
  }
  {
    name = "gcc-14.2.0.tar.xz";
    archive = fetchurl {
      sha256 = "1j9wdznsp772q15w1kl5ip0gf0bh8wkanq2sdj12b7mzkk39pcx7";
      url = "mirror://gnu/gcc/gcc-14.2.0/gcc-14.2.0.tar.xz";
    };
  }
  {
    name = "binutils-2.45.tar.xz";
    archive = fetchurl {
      sha256 = "1lpmpszs3lk9mcg7yn0m312745kbc8vlazn95h79i25ikizhw365";
      url = "mirror://gnu/binutils/binutils-2.45.tar.xz";
    };
  }
  {
    name = "acpica-unix-20250807.tar.gz";
    archive = fetchurl {
      sha256 = "0cwfm7i5a2fqq35hznnal38pgxgmnkm0v2xkb82jm1yv9014rjpa";
      url = "https://downloadmirror.intel.com/864114/acpica-unix-20250807.tar.gz";
    };
  }
  {
    name = "nasm-2.16.03.tar.bz2";
    archive = fetchurl {
      sha256 = "0mwynbnn7c4ay4rpcsyp99j49sa6j3p8gk5pigwssqfdkcaxxwxy";
      url = "https://www.nasm.us/pub/nasm/releasebuilds/2.16.03/nasm-2.16.03.tar.bz2";
    };
  }
]
