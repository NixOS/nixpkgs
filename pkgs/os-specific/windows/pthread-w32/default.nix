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
    sha256 = "1s8iny7g06z289ahdj0kzaxj0cd3wvjbd8j3bh9xlg7g444lhy9w";
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

  meta = with lib; {
    description = "POSIX threads library for Windows";
    homepage = "https://sourceware.org/pthreads-win32";
    license = licenses.lgpl21Plus;
    maintainers = [ ];
    platforms = platforms.windows;
  };
}
