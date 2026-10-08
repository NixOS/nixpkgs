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
    name = "gcc-15.2.0.tar.xz";
    archive = fetchurl {
      sha256 = "0knj4ph6y7r7yhnp1v4339af7mki5nkh7ni9b948433bhabdk3s3";
      url = "mirror://gnu/gcc/gcc-15.2.0/gcc-15.2.0.tar.xz";
    };
  }
  {
    name = "binutils-2.45.1.tar.xz";
    archive = fetchurl {
      sha256 = "199sa5igipbvz2zg0j1zgvrybphgcznq2bcnjpngs64xzvk03qaz";
      url = "mirror://gnu/binutils/binutils-2.45.1.tar.xz";
    };
  }
  {
    name = "acpica-unix-20251212.tar.gz";
    archive = fetchurl {
      sha256 = "06azmpymppycmri6wf64pgf100k7gl2sxaddnl5xsm41bwj26r28";
      url = "https://github.com/acpica/acpica/releases/download/20251212/acpica-unix-20251212.tar.gz";
    };
  }
  {
    name = "cmake-4.0.3.tar.gz";
    archive = fetchurl {
      sha256 = "1yrzkwkr2nxl8hcjkk333l9ycbw9prkg363k4km609kknyvkfdcd";
      url = "https://cmake.org/files/v4.0/cmake-4.0.3.tar.gz";
    };
  }
  {
    name = "nasm-3.01.tar.bz2";
    archive = fetchurl {
      sha256 = "1cf08p8ak15sksbzfyjxaiqggkjwc35f9yzjc9w29wzfn3riyyvs";
      url = "https://www.nasm.us/pub/nasm/releasebuilds/3.01/nasm-3.01.tar.bz2";
    };
  }
]
