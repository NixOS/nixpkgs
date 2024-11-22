{
  lib,
  autoreconfHook,
  dejagnu,
  mkAppleDerivation,
  stdenv,
  testers,
  texinfo,

  # test suite depends on dejagnu which cannot be used during bootstrapping
  # dejagnu also requires tcl which can't be built statically at the moment
  doCheck ? !(stdenv.hostPlatform.isStatic),
}:

mkAppleDerivation (finalAttrs: {
  releaseName = "libffi";

  outputs = [
    "out"
    "dev"
    "man"
    "info"
  ];

  patches = [
    # Clang 18 requires that no non-private symbols by defined after cfi_startproc. Apply the upstream libffi fix.
    ./patches/llvm-18-compatibility.patch
  ];

  # Make sure libffi is using the trampolines dylib in this package not the system one.
  postPatch = ''
    substituteInPlace src/closures.c --replace-fail /usr/lib "$out/lib"
  '';

  enableParallelBuilding = true;

  nativeBuildInputs = [
    autoreconfHook
    texinfo
  ];

  configurePlatforms = [
    "build"
    "host"
  ];

  configureFlags = [
    "--with-gcc-arch=generic" # no detection of -march= or -mtune=
    "--enable-pax_emutramp"
  ];

  # Make sure aarch64-darwin is using the trampoline dylib.
  postConfigure = lib.optionalString stdenv.hostPlatform.isAarch64 ''
    echo '#define FFI_TRAMPOLINE_WHOLE_DYLIB 1' >> aarch64-apple-darwin/fficonfig.h
  '';

  postBuild = lib.optionalString stdenv.hostPlatform.isAarch64 ''
    $CC src/aarch64/trampoline.S -dynamiclib -o libffi-trampolines.dylib \
      -Iinclude -Iaarch64-apple-darwin -Iaarch64-apple-darwin/include \
      -install_name "$out/lib/libffi-trampoline.dylib" -Wl,-compatibility_version,1 -Wl,-current_version,1
  '';

  postInstall =
    # The Darwin SDK puts the headers in `include/ffi`. Add a symlink for compatibility.
    ''
      ln -s "$dev/include" "$dev/include/ffi"
    ''
    # Install the trampoline dylib since it is build manually.
    + lib.optionalString stdenv.hostPlatform.isAarch64 ''
      cp libffi-trampolines.dylib "$out/lib/libffi-trampolines.dylib"
    '';

  preCheck = ''
    # The tests use -O0 which is not compatible with -D_FORTIFY_SOURCE.
    NIX_HARDENING_ENABLE=''${NIX_HARDENING_ENABLE/fortify3/}
    NIX_HARDENING_ENABLE=''${NIX_HARDENING_ENABLE/fortify/}
  '';

  dontStrip = stdenv.hostPlatform != stdenv.buildPlatform; # Don't run the native `strip' when cross-compiling.

  inherit doCheck;

  nativeCheckInputs = [ dejagnu ];

  passthru = {
    tests = {
      pkg-config = testers.hasPkgConfigModules {
        package = finalAttrs.finalPackage;
      };
    };
  };

  meta = {
    description = "Foreign function call interface library";
    longDescription = ''
      The libffi library provides a portable, high level programming
      interface to various calling conventions.  This allows a
      programmer to call any function specified by a call interface
      description at run-time.

      FFI stands for Foreign Function Interface.  A foreign function
      interface is the popular name for the interface that allows code
      written in one language to call code written in another
      language.  The libffi library really only provides the lowest,
      machine dependent layer of a fully featured foreign function
      interface.  A layer must exist above libffi that handles type
      conversions for values passed between the two languages.
    '';
    homepage = "https://github.com/apple-oss-distributions/libffi/";
    license = lib.licenses.mit;
    pkgConfigModules = [ "libffi" ];
  };
})
