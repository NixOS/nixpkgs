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
    name = "lld-21.1.8.src.tar.xz";
    archive = fetchurl {
      sha256 = "1lbkcgvypl459inq2ixgcachiawh1lm089rcz4m0ll2jx5g4qlnr";
      url = "https://github.com/llvm/llvm-project/releases/download/llvmorg-21.1.8/lld-21.1.8.src.tar.xz";
    };
  }
  {
    name = "llvm-21.1.8.src.tar.xz";
    archive = fetchurl {
      sha256 = "08fy0xbidf74zwva12w2v3g08iqllx4nazmjyqam18a0vgd2s0nr";
      url = "https://github.com/llvm/llvm-project/releases/download/llvmorg-21.1.8/llvm-21.1.8.src.tar.xz";
    };
  }
  {
    name = "clang-21.1.8.src.tar.xz";
    archive = fetchurl {
      sha256 = "0qma8vjqvdf8q157232ypfnh2vgc1rys90s4v36h7l106zrf7430";
      url = "https://github.com/llvm/llvm-project/releases/download/llvmorg-21.1.8/clang-21.1.8.src.tar.xz";
    };
  }
  {
    name = "cmake-21.1.8.src.tar.xz";
    archive = fetchurl {
      sha256 = "1sadfjmlwqxpql60ar9vx4h58iqqf0k0rfwsl2qfr0cczlh5yww5";
      url = "https://github.com/llvm/llvm-project/releases/download/llvmorg-21.1.8/cmake-21.1.8.src.tar.xz";
    };
  }
  {
    name = "compiler-rt-21.1.8.src.tar.xz";
    archive = fetchurl {
      sha256 = "0adjrk9ny4i17ggaghqsncbd06k0zzmm2ns4b6n0yy71mqhswm6x";
      url = "https://github.com/llvm/llvm-project/releases/download/llvmorg-21.1.8/compiler-rt-21.1.8.src.tar.xz";
    };
  }
  {
    name = "clang-tools-extra-21.1.8.src.tar.xz";
    archive = fetchurl {
      sha256 = "0ac8qb3ajxh9xnlyk71ar599qvbbf0y8lbif2chvi6ph3drpxnvd";
      url = "https://github.com/llvm/llvm-project/releases/download/llvmorg-21.1.8/clang-tools-extra-21.1.8.src.tar.xz";
    };
  }
  {
    name = "libunwind-21.1.8.src.tar.xz";
    archive = fetchurl {
      sha256 = "1g3cqgjh10valgcgq8nna7azglbhxa34ijgdr9ynbpmxqg3avs03";
      url = "https://github.com/llvm/llvm-project/releases/download/llvmorg-21.1.8/libunwind-21.1.8.src.tar.xz";
    };
  }
  {
    name = "runtimes-21.1.8.src.tar.xz";
    archive = fetchurl {
      sha256 = "1f1dfi440035fgzzc79yp4g86xkzi2w0y48xmzjcw6pwrlsrv65n";
      url = "https://github.com/llvm/llvm-project/releases/download/llvmorg-21.1.8/runtimes-21.1.8.src.tar.xz";
    };
  }
  {
    name = "third-party-21.1.8.src.tar.xz";
    archive = fetchurl {
      sha256 = "19zil44f4vs2kq8gq0rchp8iyicbzffwrjgfzagm5sja70j99sbz";
      url = "https://github.com/llvm/llvm-project/releases/download/llvmorg-21.1.8/third-party-21.1.8.src.tar.xz";
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
    name = "nasm-2.16.03.tar.bz2";
    archive = fetchurl {
      sha256 = "0mwynbnn7c4ay4rpcsyp99j49sa6j3p8gk5pigwssqfdkcaxxwxy";
      url = "https://www.nasm.us/pub/nasm/releasebuilds/2.16.03/nasm-2.16.03.tar.bz2";
    };
  }
]
