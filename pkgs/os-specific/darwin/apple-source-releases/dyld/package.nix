{
  lib,
  apple-sdk_12,
  ld64,
  mkAppleDerivation,
  cmake,
  llvmPackages,
  openssl,
  pkg-config,
  stdenvNoCC,
  fetchurl,
}:

let
  # libdyld needs CrashReporterClient.h, which is hard to find, but WebKit2 has it.
  # Fetch it directly because the Darwin stdenv bootstrap can’t depend on fetchgit.
  crashreporter_h = fetchurl {
    url = "https://raw.githubusercontent.com/apple-oss-distributions/WebKit2/WebKit2-7605.1.33.0.2/Platform/spi/Cocoa/CrashReporterClientSPI.h";
    hash = "sha256-0ybVcwHuGEdThv0PPjYQc3SW0YVOyrM3/L9zG/l1Vtk=";
  };

  launchd = apple-sdk_12.sourceRelease "launchd";
  Libc = apple-sdk_12.sourceRelease "Libc";
  libplatform = apple-sdk_12.sourceRelease "libplatform";
  libpthread = apple-sdk_12.sourceRelease "libpthread";
  xnu = apple-sdk_12.sourceRelease "xnu";

  privateHeaders = stdenvNoCC.mkDerivation {
    name = "dyld-deps-private-headers";

    buildCommand = ''
      mkdir -p "$out/include/System"
      for dir in arm i386 machine; do
        mkdir -p "$out/include/$dir"
        for file in '${xnu}/osfmk/'$dir/*; do
          name=$(basename "$file")
          # Skip copying `endian.h` because it conflicts with the SDK, breaking the build on x86_64-darwin.
          test "$name" != endian.h && cp -r "$file" "$out/include/$dir/$name"
        done
        ln -s "$out/include/$dir" "$out/include/System/$dir"
      done

      install -D -m644 -t "$out/include/System" \
        '${Libc}/stdlib/FreeBSD/atexit.h'

      mkdir -p "$out/include/System/sys"
      substitute '${xnu}/bsd/sys/fsgetpath.h' "$out/include/System/sys/fsgetpath.h" \
        --replace-fail '#ifdef __APPLE_API_PRIVATE' '#if 1'

      install -D -m644 -t "$out/include" \
        '${libplatform}/private/_simple.h' \
        '${Libc}/darwin/libc_private.h' \
        '${Libc}/darwin/subsystem.h' \
        '${ld64.src}/src/ld/cs_blobs.h' \
        '${launchd}/liblaunch/vproc_priv.h'

      substitute '${crashreporter_h}' "$out/include/CrashReporterClient.h" \
        --replace-fail 'USE(APPLE_INTERNAL_SDK)' '1' \
        --replace-fail '#import <CrashReporterClient.h>' '#include <stdint.h>' \
        --replace-fail '#else' '#define CRSetCrashLogMessage2 CRSetCrashLogMessage'

      install -D -m644 -t "$out/include/pthread" \
        '${libpthread}/private/pthread/spinlock_private.h' \
        '${libpthread}/private/pthread/tsd_private.h'

      install -D -m644 -t "$out/include/os" \
        '${xnu}/libsyscall/os/tsd.h' \
        '${xnu}/libkern/os/atomic_private.h' \
        '${xnu}/libkern/os/atomic_private_arch.h' \
        '${xnu}/libkern/os/atomic_private_impl.h' \
        '${xnu}/libkern/os/base_private.h' \
        '${libplatform}/private/os/lock_private.h'

      substituteInPlace "$out/include/os/lock_private.h" \
        --replace-fail ', bridgeos(4.0)' ""

      # This file is part of ld-prime, which is unhelpfully not included in the dyld source release.
      # Fortunately, nothing in it is actually needed to build `dyld_info` and `dsc_extractor`.
      touch "$out/include/File.h"
    '';
  };
in
mkAppleDerivation {
  releaseName = "dyld";

  outputs = [
    "out"
    "lib"
    "man"
  ];

  propagatedBuildOutputs = [ ];

  xcodeHash = "sha256-NfaENSF699xjc+eKtOm1RyXUCMD6xTaJ5+9arLllqyw=";

  patches = [
    # Disable use of private kdebug API
    ./patches/0001-Disable-kdebug-trace.patch
    # dyld_info requires `startsWith`, but it’s not normally built for `dyld_info`.
    ./patches/0002-Provide-startsWith-for-dyld_info.patch
    # dyld_info tries to weakly link against libLTO using this macro.
    ./patches/0003-Add-weaklinking_h.patch
    # The LLVMOpInfoCallback args comment out one of the args. Fix that for compatibility with nixpkgs LLVM.
    ./patches/0004-Fix-llvm-op-info-callback-args.patch
    # Some private headers depend on corecrypto, which we can’t use.
    # Use the headers from the ld64 port, which delegates to OpenSSL.
    ./patches/0005-Add-OpenSSL-based-CoreCrypto-digest-functions.patch
    # `dsc_extractor` builds a dylib, but it includes a program that can perform cache extraction.
    # This extracts just the driver into a file to make building the actual program easier.
    ./patches/0006-Add-dsc_extractor_bin_cpp.patch
  ];

  postPatch = ''
    substituteInPlace include/mach-o/dyld.h \
      --replace-fail '#ifdef __DRIVERKIT_19_0' "#if 0" \
      --replace-fail ', bridgeos(5.0)' "" \
      --replace-fail 'DYLD_EXCLAVEKIT_UNAVAILABLE' "" \
      --replace-fail '__API_UNAVAILABLE(ios, tvos, watchos) __API_UNAVAILABLE(bridgeos)' ""

    substituteInPlace include/mach-o/dyld_priv.h \
      --replace-fail ', bridgeos(3.0)' ""

    substituteInPlace include/mach-o/dyld_process_info.h \
      --replace-fail '__API_UNAVAILABLE(ios, tvos, watchos) __API_UNAVAILABLE(bridgeos)' ""

    substituteInPlace include/mach-o/utils_priv.h \
      --replace-fail 'SPI_AVAILABLE(macos(15.0), ios(18.0), tvos(18.0), watchos(11.0))' ""

    substituteInPlace libdyld/utils.cpp \
      --replace-fail 'DYLD_EXCLAVEKIT_UNAVAILABLE' ""

    cat <<EOF > libdyld/CrashReporterAnnotations.c
    #include <CrashReporterClient.h>
    struct crashreporter_annotations_t gCRAnnotations
        __attribute__((section("__DATA," CRASHREPORTER_ANNOTATIONS_SECTION)))
        = { CRASHREPORTER_ANNOTATIONS_VERSION, 0, 0, 0, 0, 0, 0 };
    EOF

    # Fix header includes
    substituteInPlace libdyld_introspection/dyld_introspection.cpp \
      --replace-fail 'dyld_introspection.h' 'mach-o/dyld_introspection.h'

    substituteInPlace dyld/Loader.h \
      --replace-fail 'dyld_priv.h' 'mach-o/dyld_priv.h'

    # Remove unused header include (since the compat shims don’t provide it).
    substituteInPlace other-tools/dsc_extractor.cpp \
      --replace-fail '#include <CommonCrypto/CommonHMAC.h>' ""

    # Specify path to `dsc_extractor.bundle` for `dlopen`
    substituteInPlace other-tools/dsc_extractor_bin.cpp \
      --subst-var lib
  '';

  env.NIX_CFLAGS_COMPILE = "-I${privateHeaders}/include";

  buildInputs = [
    apple-sdk_12 # Needed for `PLATFORM_FIRMWARE` and `PLATFORM_SEPOS` defines in `mach-o/loader.h`.
    llvmPackages.llvm
    openssl
  ];

  nativeBuildInputs = [
    cmake # CMake is required for Meson to find LLVM as a dependency.
    pkg-config
  ];

  dontUseCmakeConfigure = true;

  meta.description = "Dyld-related commands for Darwin";
}
