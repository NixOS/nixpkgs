{
  lib,
  stdenv,
  tests,
  patchelf,
}:

let
  foo = tests.stdenv-inputs.foo;
  bar = tests.stdenv-inputs.bar;

  # A simple binary compiled from source using stdenv.mkDerivation.
  # We set a RUNPATH pointing to foo and bar.
  lib-check = stdenv.mkDerivation {
    name = "lib-check-patchelfed";

    buildInputs = [
      foo
      bar
    ];

    # Enable relative RPATHs in the patchelf setup hook!
    patchelfRelativeRpaths = true;

    dontUnpack = true;

    installPhase = ''
      # Compile binary with absolute RUNPATH pointing to the store locations of foo and bar
      $CC -lfoo -lbar -Wl,-rpath,${lib.getLib foo}/lib -Wl,-rpath,${lib.getLib bar}/lib -o lib-check ${../auto-patchelf-hook-preserve-origin/lib-main.c}

      mkdir -p $out/bin $out/libexec
      cp lib-check $out/libexec/lib-check
      ln -s ../libexec/lib-check $out/bin/lib-check
    '';
  };
in
stdenv.mkDerivation {
  name = "patchelf-relative-rpaths-test";

  nativeBuildInputs = [
    patchelf
  ];

  buildCommand = ''
    symlink="${lib-check}/bin/lib-check"
    real_binary="${lib-check}/libexec/lib-check"

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
    inherit lib-check;
  };
}
