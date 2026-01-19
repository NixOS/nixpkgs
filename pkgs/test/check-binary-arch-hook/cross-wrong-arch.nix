# Test that the hook correctly detects wrong architecture binaries in a
# cross-compilation context. We cross-compile for aarch64 but include
# x86_64 binaries in both /bin and /lib, which should be detected as mismatches.
{
  pkgsCross,
  pkgs,
}:

let
  # Use aarch64 cross-compilation toolchain
  crossPkgs = pkgsCross.aarch64-multiplatform;
  # Get native x86_64 binaries to use as "wrong" binaries
  wrongArchBinary = pkgs.pkgsStatic.busybox;
  # Get a native x86_64 shared library
  wrongArchLib = pkgs.zlib;
in

crossPkgs.stdenv.mkDerivation {
  name = "check-binary-arch-test-cross-wrong";

  nativeBuildInputs = [ crossPkgs.checkBinaryArchHook ];

  # Enable debug mode for verbose output
  checkBinaryArchDebug = "1";

  dontUnpack = true;

  buildPhase = ''
    runHook preBuild
    # Copy x86_64 binary and library into our aarch64 build
    cp ${wrongArchBinary}/bin/busybox wrongarch
    chmod +x wrongarch
    cp ${wrongArchLib}/lib/libz.so wronglib.so
    cp ${wrongArchLib}/lib/libz.so wronglib-sub.so
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin $out/lib $out/lib/subdir
    cp wrongarch $out/bin/
    cp wronglib.so $out/lib/
    # Place a library in a subdirectory to test recursive search
    cp wronglib-sub.so $out/lib/subdir/
    runHook postInstall
  '';

  # Override fixupPhase to catch the expected failure
  fixupPhase = ''
    # The checkBinaryArch hook should fail here because we have x86_64
    # binaries in an aarch64 build
    if checkBinaryArch 2>&1; then
      echo "ERROR: check-binary-arch hook should have failed but didn't"
      exit 1
    fi
    echo "check-binary-arch correctly detected wrong architecture in cross-compilation"
    touch $out/success
  '';
}
