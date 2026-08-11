{
  lib,
  stdenv,
  tests,
  autoPatchelfHook,
  patchelf,
}:

let
  foo = tests.stdenv-inputs.foo;
  bar = tests.stdenv-inputs.bar;

  # We build a simple binary that links against foo and bar.
  # But we don't set any rpath during compilation so that it needs to be patched.
  lib-check = stdenv.mkDerivation {
    name = "lib-check-unpatched";

    buildInputs = [
      foo
      bar
    ];

    buildCommand = ''
      $CC -lfoo -lbar -o lib-check ${../auto-patchelf-hook-preserve-origin/lib-main.c}
      mkdir -p $out/bin
      cp lib-check $out/bin/
    '';
  };

  # Now we run autoPatchelfHook with autoPatchelfRelativeRpaths = true
  lib-check-autopatchelfed = stdenv.mkDerivation {
    name = "lib-check-autopatchelfed";

    nativeBuildInputs = [
      autoPatchelfHook
    ];

    buildInputs = [
      foo
      bar
    ];

    autoPatchelfRelativeRpaths = true;

    dontUnpack = true;

    installPhase = ''
      mkdir -p $out/bin $out/libexec
      cp ${lib-check}/bin/lib-check $out/libexec/lib-check
      ln -s ../libexec/lib-check $out/bin/lib-check
    '';
  };
in
stdenv.mkDerivation {
  name = "auto-patchelf-hook-relative-rpaths";

  nativeBuildInputs = [
    patchelf
  ];

  buildCommand = ''
    symlink="${lib-check-autopatchelfed}/bin/lib-check"
    real_binary="${lib-check-autopatchelfed}/libexec/lib-check"

    # Ensure the symlink executes successfully (verifies glibc resolves $ORIGIN relative to the real binary)
    $symlink

    # Print the rpath of the real binary to verify it contains $ORIGIN-based relative paths instead of absolute store paths
    runpath=$(patchelf --print-rpath "$real_binary")
    echo "Runpath is: $runpath"

    # Verify that runpath contains $ORIGIN/../../ and does not contain absolute nix store paths of foo/bar
    if [[ "$runpath" != *'$ORIGIN/../../'* ]]; then
      echo "Error: Runpath does not contain relative $ORIGIN entry" >&2
      exit 1
    fi

    if [[ "$runpath" == *"${foo}"* || "$runpath" == *"${bar}"* ]]; then
      echo "Error: Runpath contains absolute store path of dependencies" >&2
      exit 1
    fi

    touch $out
  '';

  meta.platforms = lib.platforms.all;
  passthru = {
    inherit lib-check lib-check-autopatchelfed;
  };
}
