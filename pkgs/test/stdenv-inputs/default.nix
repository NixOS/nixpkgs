{ lib, stdenv }:

let
  foo = stdenv.mkDerivation {
    name = "foo-test";

    dontUnpack = true;

    installPhase = ''
      mkdir -p $out/bin $out/include $out/lib
      $CC -o $out/bin/foo ${./cc-main.c}
      chmod +x $out/bin/foo
      cp ${./foo.c} $out/include/foo.h
      $CC -shared \
        ${lib.optionalString stdenv.hostPlatform.isDarwin "-Wl,-install_name,$out/lib/libfoo.dylib"} \
        -o $out/lib/libfoo${stdenv.hostPlatform.extensions.sharedLibrary} \
        ${./foo.c}
    '';
  };

  bar = stdenv.mkDerivation {
    name = "bar-test";
    outputs = [ "out" "dev" ];

    dontUnpack = true;

    installPhase = ''
      mkdir -p $out/bin $dev/include $dev/lib
      $CC -o $out/bin/bar ${./cc-main.c}
      chmod +x $out/bin/bar
      cp ${./bar.c} $dev/include/bar.h
      $CC -shared \
        ${lib.optionalString stdenv.hostPlatform.isDarwin "-Wl,-install_name,$dev/lib/libbar.dylib"} \
        -o $dev/lib/libbar${stdenv.hostPlatform.extensions.sharedLibrary} \
        ${./bar.c}
    '';
  };
in

stdenv.mkDerivation {
  name = "stdenv-inputs-test";
  phases = [ "buildPhase" ];

  buildInputs = [ foo bar ];

  buildPhase = ''
    env

    printf "checking whether binaries are available... " >&2
    foo && bar

    printf "checking whether compiler can find headers... " >&2
    $CC -o include-check ${./include-main.c}
    ./include-check

    printf "checking whether compiler can find headers... " >&2
    $CC -o include-check ${./include-main.c}
    ./include-check

    printf "checking whether compiler can find libraries... " >&2
    $CC -lfoo -lbar -o lib-check ${./lib-main.c}
    ./lib-check

    touch $out
  '';

  meta.platforms = lib.platforms.all;
}
