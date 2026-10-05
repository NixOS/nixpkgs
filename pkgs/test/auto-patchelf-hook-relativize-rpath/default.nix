{
  lib,
  stdenv,
  tests,
  autoPatchelfHook,
  patchelf,
  python3,
}:

let
  foo = tests.stdenv-inputs.foo;

  # Produce a tree containing lib/{baz.so,libs/foo.so},
  # with src/lib/libbaz.so calling code from src/lib/libs/libfoo.so.
  # These have absolute paths.
  baz-bundle = stdenv.mkDerivation {
    name = "baz-bundle";

    buildCommand = ''
      mkdir -p $out/lib/libs
      cp ${(lib.getDev foo)}/lib/libfoo.so $out/lib/libs/

      mkdir -p $out/lib/
      $CC -shared -lfoo -L$out/lib/libs -o $out/lib/libbaz.so ${./lib-baz.c}
    '';

    # No references to the foo store path.
    disallowedReferences = [
      (lib.getDev foo)
    ];
  };

  # Make baz-bundle relocatable, by running autopatchelf with the `--relativize-rpath` flag.
  # This will replace the `RPATH` of `$out/lib/libbaz.so` from `$out/lib/libs` to `$ORIGIN/libs`.
  baz-bundle-relocatable = stdenv.mkDerivation {
    name = "baz-bundle-relocatable";

    nativeBuildInputs = [
      autoPatchelfHook
    ];

    autoPatchelfFlags = [ "--relativize-rpath" ];

    dontUnpack = true;

    # we don't set buildCommand because we want to ensure fixupPhase
    # (containing autoPatchelfHook) is run.
    installPhase = ''
      mkdir -p $out
      cp -R ${baz-bundle}/lib $out/lib
    '';

    # Now these two .so files refer neither to `baz-bundle`, nor contain self-references.
    disallowedReferences = [
      baz-bundle
      "out"
    ];
  };

in
# Pretend a user consumed `baz-bundle-relocatable` as an artifact,
# copied to ./libs/baz-bundle, and calls `baz` from `libbaz.so` from their code.
# Ensure this works, which requires `baz()` to still be able to find `foo()`.
stdenv.mkDerivation {
  name = "auto-patchelf-hook-relativize-rpath";
  nativeBuildInputs = [
    patchelf
    python3
  ];

  buildCommand = ''
    mkdir -p libs/baz-bundle
    cp -R ${baz-bundle-relocatable}/lib/* libs/baz-bundle/

    echo "RPATHs:"
    echo -n "libs/baz-bundle/libbaz.so:     "
    patchelf --print-rpath libs/baz-bundle/libbaz.so
    echo -n "libs/baz-bundle/lib/libfoo.so: "
    patchelf --print-rpath libs/baz-bundle/libs/libfoo.so

    cp ${./main.py} main.py
    python main.py |& tee /dev/stderr | grep -q "foo returned 42"

    touch $out
  '';

  meta.platforms = lib.platforms.linux;
}
