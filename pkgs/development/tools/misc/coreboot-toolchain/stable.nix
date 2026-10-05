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
    name = "mpc-1.4.1.tar.xz";
    archive = fetchurl {
      sha256 = "0cg9ff6vzl42d65zfc5bmld526b5rsladm4jr6vx6jqn5z9lq84i";
      url = "mirror://gnu/mpc/mpc-1.4.1.tar.xz";
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
    name = "binutils-2.46.1.tar.xz";
    archive = fetchurl {
      sha256 = "1r4l2bmp36ziwa9080gb6z6ji3vnvn1p1jrni7g7ck52rc4sf9z1";
      url = "mirror://gnu/binutils/binutils-2.46.1.tar.xz";
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
    name = "cmake-4.3.4.tar.gz";
    archive = fetchurl {
      sha256 = "1nmd67lrk14pq6bqlrr5yc6l9qdpdvf1wawzadjdfjgbp6bzivzx";
      url = "https://cmake.org/files/v4.3/cmake-4.3.4.tar.gz";
    };
  }
  {
    name = "nasm-3.02.tar.bz2";
    archive = fetchurl {
      sha256 = "1brrwa9hpkqniwabwvb9rbaw2yaaqq1nbrylm7j7jlv1h4rdjznf";
      url = "https://www.nasm.us/pub/nasm/releasebuilds/3.02/nasm-3.02.tar.bz2";
    };
  }
]
