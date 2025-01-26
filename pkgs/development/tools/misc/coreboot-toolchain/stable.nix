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
    name = "mpfr-4.2.1.tar.xz";
    archive = fetchurl {
      sha256 = "1cnb3y7y351qg6r7ynwsgaykm7l2a8zg2nlljs4rf9k778shfy17";
      url = "mirror://gnu/mpfr/mpfr-4.2.1.tar.xz";
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
    name = "binutils-2.43.1.tar.xz";
    archive = fetchurl {
      sha256 = "1z9d2f0894xvjlfnvni4wbxnqgqd42j9x8wpnwc13if4lc145xqk";
      url = "mirror://gnu/binutils/binutils-2.43.1.tar.xz";
    };
  }
  {
    name = "acpica-unix-20230628.tar.gz";
    archive = fetchurl {
      sha256 = "1kjwzyfrmw0fhawjvpqib3l5jxdlcpj3vv92sb7ls8ixbrs6m1w6";
      url = "https://downloadmirror.intel.com/783534/acpica-unix-20230628.tar.gz";
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
