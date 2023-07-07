{ lib, gccStdenv, fetchFromGitLab, cudatoolkit
, cudaSupport ? false
, pkg-config }:

gccStdenv.mkDerivation rec {
  pname = "truecrack";
  version = "3.6";

  src = fetchFromGitLab {
    owner = "kalilinux";
    repo = "packages/truecrack";
    rev = "debian/${version}+git20150326-0kali1";
    sha256 = "+Rw9SfaQtO1AJO6UVVDMCo8DT0dYEbv7zX8SI+pHCRQ=";
  };

  configureFlags = (if cudaSupport then [
    "--with-cuda=${cudatoolkit}"
  ] else [
    "--enable-cpu"
  ]);

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = lib.optionals cudaSupport [
    cudatoolkit
  ];

  # Workaround build failure on -fno-common toolchains like upstream
  # gcc-10. Otherwise build fails as:
  #   ld: CpuAes.o:/build/source/src/Crypto/CpuAes.h:1233: multiple definition of
  #     `t_rc'; CpuCore.o:/build/source/src/Crypto/CpuAes.h:1237: first defined here
  # TODO: remove on upstream fixes it:
  #   https://gitlab.com/kalilinux/packages/truecrack/-/issues/1
  env.NIX_CFLAGS_COMPILE = "-fcommon";

  installFlags = [ "prefix=$(out)" ];
  enableParallelBuilding = true;

  meta = with lib; {
    description = "TrueCrack is a brute-force password cracker for TrueCrypt volumes. It works on Linux and it is optimized for Nvidia Cuda technology.";
    homepage = "https://gitlab.com/kalilinux/packages/truecrack";
    broken = cudaSupport;
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ ethancedwards8 ];
  };
}
