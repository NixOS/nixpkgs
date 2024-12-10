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
    name = "gcc-13.2.0.tar.xz";
    archive = fetchurl {
      sha256 = "1nj3qyswcgc650sl3h0480a171ixp33ca13zl90p61m689jffxg2";
      url = "mirror://gnu/gcc/gcc-13.2.0/gcc-13.2.0.tar.xz";
    };
  }
  {
    name = "binutils-2.41.tar.xz";
    archive = fetchurl {
      sha256 = "0l3l003dynq11ppr2h8p0cfc7zyky8ilfwg60sbfan9lwa4mg6mf";
      url = "mirror://gnu/binutils/binutils-2.41.tar.xz";
    };
  }
  {
    name = "R06_28_23.tar.gz";
    archive = fetchurl {
      sha256 = "0cadxihshyrjplrx01vna13r1m2f6lj1klw7mh8pg2m0gjdpjj12";
      url = "https://github.com/acpica/acpica/archive/refs/tags/R06_28_23.tar.gz";
    };
  }
  {
    name = "nasm-2.16.01.tar.bz2";
    archive = fetchurl {
      sha256 = "0bmv8xbzck7jim7fzm6jnwiahqkprbpz6wzhg53irm28w0pavdim";
      url = "https://www.nasm.us/pub/nasm/releasebuilds/2.16.01/nasm-2.16.01.tar.bz2";
    };
  }
]
