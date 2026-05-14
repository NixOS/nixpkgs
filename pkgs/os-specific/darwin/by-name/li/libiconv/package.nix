{
  lib,
  atf,
  gperf,
  mkAppleDerivation,
  pkg-config,
  stdenv,
}:

let
  inherit (stdenv) hostPlatform;
in
mkAppleDerivation (finalAttrs: {
  releaseName = "libiconv";

  outputs = [
    "out"
    "dev"
  ];

  xcodeHash = "sha256-IiTqhEJIZ8JYjlpBS7ITwYlp8ndU6cehus9TIr+5LYM=";

  patches = [
    # Use gperf to implement module loading statically by looking up the module functions in the static binary.
    ./patches/0001-Support-static-module-loading.patch
    # Avoid out of bounds write with ISO-2022
    ./patches/0002-Fix-ISO-2022-out-of-bounds-write-with-encoded-charac.patch
  ];

  # Propagate `out` only when there are dylibs to link (i.e., don’t propagate when doing a static build).
  propagatedBuildOutputs = lib.optionalString (!hostPlatform.isStatic) "out";

  postPatch = ''
    # Work around unnecessary private API usage in libcharset.
    mkdir -p libcharset/os && cat <<EOF > libcharset/os/variant_private.h
      #pragma once
      #include <stdbool.h>
      static inline bool os_variant_has_internal_content(const char*) { return false; }
    EOF

    # Add additional test cases found while working on packaging libiconv in nixpkgs.
    cp ${./nixpkgs_test.c} tests/libiconv/nixpkgs_test.c
  ''
  + lib.optionalString hostPlatform.isStatic ''
    cp ${./static-modules.gperf} static-modules.gperf
  '';

  # Dynamic builds use `dlopen` to load modules, but static builds have to link them all.
  # `gperf` is used to generate a lookup table from module to ops functions.
  nativeBuildInputs = lib.optionals hostPlatform.isStatic [ gperf ];

  mesonFlags = [ (lib.mesonBool "tests" finalAttrs.finalPackage.doInstallCheck) ];

  postBuild =
    # Add `libcharset.a` contents to `libiconv.a` to duplicate the reexport from `libiconv.dylib`.
    lib.optionalString hostPlatform.isStatic ''
      ${stdenv.cc.targetPrefix}ar qL libiconv.a libcharset.a
    '';

  postInstall =
    lib.optionalString (hostPlatform.isDarwin && !hostPlatform.isStatic) ''
      ${stdenv.cc.targetPrefix}install_name_tool "$out/lib/libiconv.2.dylib" \
        -change '@rpath/libcharset.1.dylib' "$out/lib/libcharset.1.dylib"
    ''
    # Move the static library to the `dev` output
    + lib.optionalString hostPlatform.isStatic ''
      moveToOutput lib "$dev"
    '';

  # Tests have to be run in `installCheckPhase` because libiconv expects to `dlopen`
  # modules from `$out/lib/i18n`.
  nativeInstallCheckInputs = [ pkg-config ];
  installCheckInputs = [ atf ];

  doInstallCheck = stdenv.buildPlatform.canExecute hostPlatform;

  # Can’t use `mesonCheckPhase` because it runs the wrong hooks for `installCheckPhase`.
  installCheckPhase = ''
    runHook preInstallCheck
    meson test --no-rebuild --print-errorlogs --timeout-multiplier=0
    runHook postInstallCheck
  '';

  meta = {
    description = "Iconv(3) implementation";
    license = [
      lib.licenses.bsd2
      lib.licenses.bsd3
    ]
    ++ lib.optional finalAttrs.finalPackage.doInstallCheck lib.licenses.apple-psl10;
    mainProgram = "iconv";
  };
})
