{ fetchurl }: [
  {
    name = "gmp-6.2.1.tar.xz";
    archive = fetchurl {
      sha256 = "1wml97fdmpcynsbw9yl77rj29qibfp652d0w3222zlfx5j8jjj7x";
      url = "mirror://gnu/gmp/gmp-6.2.1.tar.xz";
    };
  }
  {
    name = "mpfr-4.2.0.tar.xz";
    archive = fetchurl {
      sha256 = "14yr4sf4mys64nzbgnd997l6l4n8l9vsjnnvnb0lh4jh2ggpi8q6";
      url = "mirror://gnu/mpfr/mpfr-4.2.0.tar.xz";
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
    name = "gcc-11.3.0.tar.xz";
    archive = fetchurl {
      sha256 = "0fdclcwf728wbq52vphfcjywzhpsjp3kifzj3pib3xcihs0z4z5l";
      url = "mirror://gnu/gcc/gcc-11.3.0/gcc-11.3.0.tar.xz";
    };
  }
  {
    name = "binutils-2.40.tar.xz";
    archive = fetchurl {
      sha256 = "1qfqr7gw9k5hhaj6sllmis109qxq5354l2nivrlz65vz5lklr2hg";
      url = "mirror://gnu/binutils/binutils-2.40.tar.xz";
    };
  }
  {
    name = "R10_20_22.tar.gz";
    archive = fetchurl {
      sha256 = "11iv3jrz27g7bv7ffyxsrgm4cq60cld2gkkl008p3lcwfyqpx88s";
      url = "https://github.com/acpica/acpica/archive/refs/tags/R10_20_22.tar.gz";
    };
  }
  {
    name = "nasm-2.15.05.tar.bz2";
    archive = fetchurl {
      sha256 = "1l1gxs5ncdbgz91lsl4y7w5aapask3w02q9inayb2m5bwlwq6jrw";
      url = "https://www.nasm.us/pub/nasm/releasebuilds/2.15.05/nasm-2.15.05.tar.bz2";
    };
  }
]
