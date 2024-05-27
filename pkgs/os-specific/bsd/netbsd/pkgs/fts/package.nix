{
  mkDerivation,
  bsdSetupHook,
  netbsdSetupHook,
  rsync,
  compatIfNeeded,
  fetchNetBSD,
}:

mkDerivation {
  pname = "fts";
  path = "include/fts.h";
  sha256 = "01d4fpxvz1pgzfk5xznz5dcm0x0gdzwcsfm1h3d0xc9kc6hj2q77";
  version = "9.2";
  nativeBuildInputs = [
    bsdSetupHook
    netbsdSetupHook
    rsync
  ];
  propagatedBuildInputs = compatIfNeeded;
  extraPaths = [
    (fetchNetBSD "lib/libc/gen/fts.c" "9.2" "1a8hmf26242nmv05ipn3ircxb0jqmmi66rh78kkyi9vjwkfl3qn7")
    (fetchNetBSD "lib/libc/include/namespace.h" "9.2"
      "0kksr3pdwdc1cplqf5z12ih4cml6l11lqrz91f7hjjm64y7785kc"
    )
    (fetchNetBSD "lib/libc/gen/fts.3" "9.2" "1asxw0n3fhjdadwkkq3xplfgqgl3q32w1lyrvbakfa3gs0wz5zc1")
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
