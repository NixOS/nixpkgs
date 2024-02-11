{ lib, stdenv, fetchurl, perl, libunwind, buildPackages, gitUpdater, elfutils }:

stdenv.mkDerivation rec {
  pname = "strace";
  version = "6.7";

  src = fetchurl {
    url = "https://strace.io/files/${version}/${pname}-${version}.tar.xz";
    sha256 = "sha256-IJAgHho/8yhG9P5CHBFjsV9EC7OOMTVdCfgtOUmSKvc=";
  };

  depsBuildBuild = [ buildPackages.stdenv.cc ];
  nativeBuildInputs = [ perl ];

  # On RISC-V platforms, LLVM's libunwind implementation is unsupported by strace.
  # The build will silently fall back and -k will not work on RISC-V.
  buildInputs = [ libunwind elfutils ]; # support -k and -kk

  configureFlags = [ "--enable-mpers=check" ];

  passthru.updateScript = gitUpdater {
    # No nicer place to find latest release.
    url = "https://github.com/strace/strace.git";
    rev-prefix = "v";
  };

  meta = with lib; {
    homepage = "https://strace.io/";
    description = "A system call tracer for Linux";
    license =  with licenses; [ lgpl21Plus gpl2Plus ]; # gpl2Plus is for the test suite
    platforms = platforms.linux;
    maintainers = with maintainers; [ globin ma27 qyliss ];
    mainProgram = "strace";
  };
}
