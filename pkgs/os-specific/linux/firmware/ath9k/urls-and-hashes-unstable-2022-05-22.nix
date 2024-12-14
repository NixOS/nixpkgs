rec {
  BASEDIR = "$NIX_BUILD_TOP";
  BINUTILS_URL = "https://ftp.gnu.org/gnu/binutils/binutils-${BINUTILS_VER}.tar.bz2";
  DL_DIR = "${TOOLCHAIN_DIR}/dl";
  GMP_SUM = "f51c99cb114deb21a60075ffb494c1a210eb9d7cb729ed042ddb7de9534451ea";
  GMP_URL = "https://ftp.gnu.org/gnu/gmp/gmp-${GMP_VER}.tar.bz2";
  GCC_URL = "https://ftp.gnu.org/gnu/gcc/gcc-${GCC_VER}/gcc-${GCC_VER}.tar.gz";
  BINUTILS_DIR = "binutils-${BINUTILS_VER}";
  GCC_VER = "10.2.0";
  MPFR_URL = "https://ftp.gnu.org/gnu/mpfr/mpfr-${MPFR_VER}.tar.bz2";
  MPC_VER = "1.1.0";
  GMP_DIR = "gmp-${GMP_VER}";
  MPC_URL = "https://ftp.gnu.org/gnu/mpc/mpc-${MPC_VER}.tar.gz";
  GCC_DIR = "gcc-${GCC_VER}";
  MPC_SUM = "6985c538143c1208dcb1ac42cedad6ff52e267b47e5f970183a3e75125b43c2e";
  GCC_SUM = "27e879dccc639cd7b0cc08ed575c1669492579529b53c9ff27b0b96265fa867d";
  BINUTILS_SUM = "7d24660f87093670738e58bcc7b7b06f121c0fcb0ca8fc44368d675a5ef9cff7";
  MPFR_DIR = "mpfr-${MPFR_VER}";
  MPC_DIR = "mpc-${MPC_VER}";
  MPFR_VER = "4.1.0";
  GMP_VER = "6.2.0";
  BINUTILS_VER = "2.35";
  BUILD_DIR = "${TOOLCHAIN_DIR}/build";
  MPFR_SUM = "feced2d430dd5a97805fa289fed3fc8ff2b094c02d05287fd6133e7f1f0ec926";
  TOOLCHAIN_DIR = "${BASEDIR}/toolchain";
}
