# This is a test for autoPatchelfHook. To test it, we just need a simple binary
# which uses the hook. We took the derivation from tonelib-jam, which sounds
# like a good candidate with a small closure, and trimmed it down.

{
  stdenv,
  lib,
  fetchurl,
  autoPatchelfHook,
  dpkg,
  freetype,
  curl,
  # This test checks that the behavior of autoPatchelfHook is correct whether
  # __structuredAttrs
  # (https://nixos.org/manual/nix/stable/language/advanced-attributes#adv-attr-structuredAttrs)
  # is set or not. Hence __structuredAttrs is provided as a parameter.
  __structuredAttrs,
}:

let
  runtimeDependencies = [
    (lib.getLib curl)
    "/some/dep"
    "/some/other/dep"
  ]
  # A dependency with space only works with __structuredAttrs set to true.
  ++ lib.lists.optional __structuredAttrs "/some/dep with space";
in

stdenv.mkDerivation {
  name = "auto-patchelf-test";

  src = fetchurl {
    url = "https://tonelib.net/download/221222/ToneLib-Jam-amd64.deb";
    sha256 = "sha256-c6At2lRPngQPpE7O+VY/Hsfw+QfIb3COIuHfbqqIEuM=";
  };

  unpackCmd = ''
    dpkg -x $curSrc source
  '';

  nativeBuildInputs = [
    dpkg
    autoPatchelfHook
  ];

  installPhase = ''
    mv usr $out
  '';

  buildInputs = [
    freetype
  ];

  autoPatchelfIgnoreMissingDeps = [
    "libGL.so.1"
    "libasound.so.2"
  ];

  inherit runtimeDependencies;

  # Additional phase performing the actual test.
  installCheckPhase =
    let
      allDeps = runtimeDependencies ++ [
        (lib.getLib freetype)
      ];
    in
    ''
      local binary="$out/bin/ToneLib-Jam"
      local interpreter=$(patchelf --print-interpreter $binary)
      local runpath=$(patchelf --print-rpath $binary)
      local glibcStorePath="${stdenv.cc.libc}"

      # Check that the glibc path is a prefix of the interpreter. If
      # autoPatchelfHook ran correctly, the binary should have set the interpreter
      # to point to the store.
      echo "[auto-patchelf-hook-test]: Check that the interpreter is in the store"
      test "''${interpreter#$glibcStorePath}" != "$interpreter"

      readarray -td':' runpathArray < <(echo -n "$runpath")

      echo "[auto-patchelf-hook-test]: Check that the runpath has the right number of entries"
      test "''${#runpathArray[@]}" -eq ${toString (builtins.length allDeps)}

      echo "[auto-patchelf-hook-test]: Check that the runpath contains the expected runtime deps"
    ''
    + lib.strings.concatStringsSep "\n" (
      lib.lists.imap0 (
        i: path:
        let
          iAsStr = toString i;
        in
        ''
          echo "[auto-patchelf-hook-test]: Check that entry ${iAsStr} is ${path}"
          test "''${paths[${iAsStr}]}" = "$path"
        ''
      ) allDeps
    );

  doInstallCheck = true;
  inherit __structuredAttrs;
  meta = {
    # Downloads an x86_64-linux only binary
    platforms = [ "x86_64-linux" ];
  };
}
