{
  lib,
  stdenv,
  fetchurl,
  perl,
  libunwind,
  buildPackages,
  gitUpdater,
  elfutils,
}:

stdenv.mkDerivation rec {
  pname = "strace";
  version = "6.12";

  src = fetchurl {
    url = "https://strace.io/files/${version}/${pname}-${version}.tar.xz";
    hash = "sha256-xH2pO+RbYFX03HQdfyDvr1DKEBYKWxAMEJspT9nAvf4=";
  };

  depsBuildBuild = [ buildPackages.stdenv.cc ];
  nativeBuildInputs = [ perl ];

  enableParallelBuilding = true;

  # libunwind for -k.
  # On RISC-V platforms, LLVM's libunwind implementation is unsupported by strace.
  # The build will silently fall back and -k will not work on RISC-V.
  buildInputs =
    [ libunwind ]
    # -kk
    ++ lib.optional (lib.meta.availableOn stdenv.hostPlatform elfutils) elfutils;

  configureFlags = [ "--enable-mpers=check" ];

  passthru.updateScript = gitUpdater {
    # No nicer place to find latest release.
    url = "https://github.com/strace/strace.git";
    rev-prefix = "v";
  };

  meta = with lib; {
    homepage = "https://strace.io/";
    description = "A system call tracer for Linux";
    license = with licenses; [
      lgpl21Plus
      gpl2Plus
    ]; # gpl2Plus is for the test suite
    platforms = platforms.linux;
    maintainers = with maintainers; [
      globin
      ma27
      qyliss
    ];
    mainProgram = "strace";
  };
}
