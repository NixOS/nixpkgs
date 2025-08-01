{
  lib,
  stdenv,
  fetchzip,
}:

stdenv.mkDerivation {
  pname = "pthreads-w32";
  version = "2.9.1";

  src = fetchzip {
    url = "https://sourceware.org/pub/pthreads-win32/pthreads-w32-2-9-1-release.tar.gz";
    hash = "sha256-PHlICSHvPNoTXEOituTmozEgu/oTyAZVQuIb8I63Eek=";
  };

  makeFlags = [
    "CROSS=${stdenv.cc.targetPrefix}"
    "GC-static"
  ];

  installPhase = ''
    runHook preInstall

    install -D libpthreadGC2.a $out/lib/libpthread.a

    runHook postInstall
  '';

  meta = {
    description = "POSIX threads library for Windows";
    homepage = "https://sourceware.org/pthreads-win32";
    license = lib.licenses.lgpl21Plus;
    maintainers = [ lib.maintainers.RossSmyth ];
    platforms = lib.platforms.windows;
    teams = [ lib.teams.windows ];
  };
}
