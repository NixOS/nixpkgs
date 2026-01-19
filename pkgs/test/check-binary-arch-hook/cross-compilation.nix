# Test that cross-compiled binaries pass the check when built for the correct
# target architecture. This verifies the hook works correctly in cross-compilation
# scenarios where the build platform differs from the host platform.
# Tests both /bin executables and /lib shared objects.
{
  pkgsCross,
}:

let
  # Use aarch64 cross-compilation toolchain
  pkgs = pkgsCross.aarch64-multiplatform;
in

pkgs.stdenv.mkDerivation {
  name = "check-binary-arch-test-cross";

  nativeBuildInputs = [ pkgs.checkBinaryArchHook ];

  # Enable debug mode for verbose output
  checkBinaryArchDebug = "1";

  dontUnpack = true;

  buildPhase = ''
    runHook preBuild

    # Create a test executable
    echo 'int main() { return 0; }' > test.c
    $CC -o test test.c

    # Create a test shared library
    echo 'int foo() { return 42; }' > libtest.c
    $CC -shared -fPIC -o libtest.so libtest.c

    # Create another shared library for subdirectory test
    echo 'int bar() { return 99; }' > libsub.c
    $CC -shared -fPIC -o libsub.so libsub.c

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin $out/lib $out/lib/subdir
    cp test $out/bin/
    cp libtest.so $out/lib/
    # Place a library in a subdirectory to test recursive search
    cp libsub.so $out/lib/subdir/
    runHook postInstall
  '';

  # The hook runs in fixupPhase - if we get here, the cross-compiled binary
  # and library were correctly identified as matching the target architecture
  postFixup = ''
    touch $out/success
  '';
}
