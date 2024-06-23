{
  mkDerivation,
  bsdSetupHook,
  netbsdSetupHook,
  compatIfNeeded,
}:

mkDerivation {
  pname = "fts";
  path = "include/fts.h";
  nativeBuildInputs = [
    bsdSetupHook
    netbsdSetupHook
  ];
  propagatedBuildInputs = compatIfNeeded;
  extraPaths = [
    "lib/libc/gen/fts.c"
    "lib/libc/include/namespace.h"
    "lib/libc/gen/fts.3"
  ];
  skipIncludesPhase = true;
  buildPhase = ''
    "$CC" -c -Iinclude -Ilib/libc/include lib/libc/gen/fts.c \
        -o lib/libc/gen/fts.o
    "$AR" -rsc libfts.a lib/libc/gen/fts.o
  '';
  installPhase = ''
    runHook preInstall

    install -D lib/libc/gen/fts.3 $out/share/man/man3/fts.3
    install -D include/fts.h $out/include/fts.h
    install -D lib/libc/include/namespace.h $out/include/namespace.h
    install -D libfts.a $out/lib/libfts.a

    runHook postInstall
  '';
  setupHooks = [
    ../../../../../build-support/setup-hooks/role.bash
    ./fts-setup-hook.sh
  ];
}
