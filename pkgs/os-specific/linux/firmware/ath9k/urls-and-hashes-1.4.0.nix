rec {
  BASEDIR="$NIX_BUILD_TOP";
BINUTILS_URL = "https://ftp.gnu.org/gnu/binutils/binutils-${BINUTILS_VER}.tar.bz2";
DL_DIR = "${TOOLCHAIN_DIR}/dl";
GMP_URL = "https://ftp.gnu.org/gnu/gmp/gmp-${GMP_VER}.tar.bz2";
GCC_URL = "https://ftp.gnu.org/gnu/gcc/gcc-${GCC_VER}/gcc-${GCC_VER}.tar.bz2";
BINUTILS_DIR = "binutils-${BINUTILS_VER}";
GCC_VER = "4.7.4";
MPFR_URL = "https://ftp.gnu.org/gnu/mpfr/mpfr-${MPFR_VER}.tar.bz2";
MPC_VER = "1.0.1";
GMP_DIR = "gmp-${GMP_VER}";
MPC_URL = "https://ftp.gnu.org/gnu/mpc/mpc-${MPC_VER}.tar.gz";
GCC_DIR = "gcc-${GCC_VER}";
MPFR_DIR = "mpfr-${MPFR_VER}";
MPC_DIR = "mpc-${MPC_VER}";
MPFR_VER = "3.1.1";
GMP_VER = "5.0.5";
BINUTILS_VER = "2.23.1";
BUILD_DIR = "${TOOLCHAIN_DIR}/build";
TOOLCHAIN_DIR = "${BASEDIR}/toolchain";
GCC_SUM = "sha256-kuYcbcOgpEnmLXKjgYX9pVAWioZwLeoHEl69PsOZYoI=";
MPFR_SUM = "sha256-e2bD8T3IOF8IJkyAWFPz4aju2rgHHVgvPmYZccms1f0=";
MPC_SUM = "sha256-7VqBXP6lJdx3jfDLN0aLnBtVSq8w2TKLFDHKcFt0AP8=";
GMP_SUM = "sha256-H1iKrMxBu5rtlG+f44Uhwm2LKQ0APF34B/ZWkPKq3sk=";
BINUTILS_SUM = "sha256-KrLlsD4IbRLGKV+DGtrUaz4UEKOiNJM6Lo+sZssuehk=";
}
