{ lib, stdenv, fetchurl, perl, libunwind, buildPackages, gitUpdater, elfutils }:

stdenv.mkDerivation rec {
  pname = "strace";
  version = "6.11";

  src = fetchurl {
    url = "https://strace.io/files/${version}/${pname}-${version}.tar.xz";
    hash = "sha256-gyYlg6NSnwLDUBqouKx3K0y8A9yTTpi6tuSINibig6U=";
  };

  depsBuildBuild = [ buildPackages.stdenv.cc ];
  nativeBuildInputs = [ perl ];

  # libunwind for -k.
  # On RISC-V platforms, LLVM's libunwind implementation is unsupported by strace.
  # The build will silently fall back and -k will not work on RISC-V.
  buildInputs = [ libunwind ]
    # -kk
    ++ lib.optional (lib.meta.availableOn stdenv.hostPlatform elfutils) elfutils;

  configureFlags = [ "--enable-mpers=check" ]
    ++ lib.optional stdenv.cc.isClang "CFLAGS=-Wno-unused-function";

  passthru.updateScript = gitUpdater {
    # No nicer place to find latest release.
    url = "https://github.com/strace/strace.git";
    rev-prefix = "v";
  };

  meta = with lib; {
    homepage = "https://strace.io/";
    description = "System call tracer for Linux";
    license =  with licenses; [ lgpl21Plus gpl2Plus ]; # gpl2Plus is for the test suite
    platforms = platforms.linux;
    maintainers = with maintainers; [ globin ma27 qyliss ];
    mainProgram = "strace";
  };
}
