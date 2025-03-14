{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchurl,
  makeSetupHook,
  cmake,
  pkg-config,
  launchd,
  libdispatch,
  python3Minimal,
  libxml2,
  objc4,
  icu,
}:

let
  # 10.12 adds a new sysdir.h that our version of CF in the main derivation depends on, but
  # isn't available publicly, so instead we grab an older version of the same file that did
  # not use sysdir.h, but provided the same functionality. Luckily it's simple :) hack hack
  sysdir-free-system-directories = fetchurl {
    url = "https://raw.githubusercontent.com/apple/swift-corelibs-foundation/9a5d8420f7793e63a8d5ec1ede516c4ebec939f0/CoreFoundation/Base.subproj/CFSystemDirectories.c";
    sha256 = "0krfyghj4f096arvvpf884ra5czqlmbrgf8yyc0b3avqmb613pcc";
  };
in

stdenv.mkDerivation {
  pname = "swift-corefoundation";
  version = "unstable-2018-09-14";

  src = fetchFromGitHub {
    owner = "apple";
    repo = "swift-corelibs-foundation";
    rev = "71aaba20e1450a82c516af1342fe23268e15de0a";
    sha256 = "17kpql0f27xxz4jjw84vpas5f5sn4vdqwv10g151rc3rswbwln1z";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    python3Minimal
  ];
  buildInputs = [
    (lib.getDev launchd)
    libdispatch
    libxml2
    objc4
    icu
  ];

  patches = [
    ./0001-Add-missing-TARGET_OS_-defines.patch
    # CFMessagePort.h uses `bootstrap_check_in` without declaring it, which is defined in the launchd headers.
    ./0002-Add-missing-launchd-header.patch
    # CFURLComponents fails to build with clang 16 due to an invalid pointer conversion. This is fixed upstream.
    ./0003-Fix-incompatible-pointer-conversion.patch
    # Fix `CMakeLists.txt` to allow it to be used instead of `build.py` to build on Darwin.
    ./0004-Fix-Darwin-cmake-build.patch
    # Install CF framework in `$out/Library/Frameworks` instead of `$out/System/Frameworks`.
    ./0005-Fix-framework-installation-path.patch
    # Build a framework that matches the contents of the system CoreFoundation. This patch adds
    # versioning and drops the prefix and suffix, so the dynamic library is named `CoreFoundation`
    # instead of `libCoreFoundation.dylib`.
    ./0006-System-CF-framework-compatibility.patch
    # Link against the nixpkgs ICU instead of using Apple’s vendored version.
    ./0007-Use-nixpkgs-icu.patch
    # Don’t link against libcurl. This breaks a cycle between CF and curl, which depends on CF and
    # uses the SystemConfiguration framework to support NAT64.
    # This is safe because the symbols provided in CFURLSessionInterface are not provided by the
    # system CoreFoundation. They are meant to be used by the implementation of `NSURLSession` in
    # swift-corelibs-foundation, which is not built because it is not fully compatible with the
    # system Foundation used on Darwin.
    ./0008-Dont-link-libcurl.patch
  ];

  postPatch = ''
    cd CoreFoundation

    cp ${sysdir-free-system-directories} Base.subproj/CFSystemDirectories.c

    # Includes xpc for some initialization routine that they don't define anyway, so no harm here
    substituteInPlace PlugIn.subproj/CFBundlePriv.h \
      --replace '#if (TARGET_OS_MAC' '#if (0'

    # Why do we define __GNU__? Is that normal?
    substituteInPlace Base.subproj/CFAsmMacros.h \
      --replace '#if defined(__GNU__) ||' '#if 0 &&'

    # The MIN macro doesn't seem to be defined sensibly for us. Not sure if our stdenv or their bug
    substituteInPlace Base.subproj/CoreFoundation_Prefix.h \
      --replace '#if DEPLOYMENT_TARGET_WINDOWS || DEPLOYMENT_TARGET_LINUX' '#if 1'
  '';

  env.NIX_CFLAGS_COMPILE = toString [
    # Silence warnings regarding other targets
    "-Wno-error=undef-prefix"
    # Avoid redefinitions when including objc headers
    "-DINCLUDE_OBJC=1"
  ];

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=ON"
    "-DCF_ENABLE_LIBDISPATCH=OFF"
  ];

  enableParallelBuilding = true;

  postInstall = ''
    install_name_tool -id '@rpath/CoreFoundation.framework/Versions/A/CoreFoundation' \
      "$out/Library/Frameworks/CoreFoundation.framework/Versions/A/CoreFoundation"

    mkdir -p "$out/nix-support"
  '';
}
