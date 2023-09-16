{ lib, stdenvNoCC, buildPackages, fetchzip, fetchFromGitHub
, appleDerivation', AvailabilityVersions, xnu, Libc, Libm, libdispatch, Libinfo
, dyld, Csu, architecture, libclosure, CarbonHeaders, ncurses, CommonCrypto
, copyfile, removefile, libresolvHeaders, libresolv, Libnotify, libmalloc, libplatform, libpthread
, mDNSResponder, launchd, libutilHeaders, hfsHeaders, darwin-stubs
, headersOnly ? false
, withCsu ? !headersOnly
, withLibresolv ? !headersOnly
}:

let
  darling.src = fetchzip {
    url = "https://github.com/darlinghq/darling/archive/d2cc5fa748003aaa70ad4180fff0a9a85dc65e9b.tar.gz";
    hash = "sha256-/YynrKJdi26Xj4lvp5wsN+TAhZjonOrNNHuk4L5tC7s=";
    postFetch = ''
      # The archive contains both `src/opendirectory` and `src/OpenDirectory`.
      # Since neither directory is used for anything, we just remove them to avoid
      #  the potential issue where file systems with different case sensitivity produce
      #  different hashes.
      rm -rf $out/src/{OpenDirectory,opendirectory}
    '';
  };

  # Libsystem needs `asl.h` from syslog. This is the version corresponding to the 10.12 SDK
  # source release, but it hasn’t changed in newer versions.
  syslog.src = fetchFromGitHub {
    owner = "apple-oss-distributions";
    repo = "syslog";
    rev = "syslog-349.50.5";
    hash = "sha256-tXLW/TNsluhO1X9Rv3FANyzyOe5TE/hZz0gVo7JGvHA=";
  };
in
appleDerivation' stdenvNoCC {
  dontBuild = true;
  dontFixup = true;

  installPhase = ''
    export NIX_ENFORCE_PURITY=

    mkdir -p $out/lib $out/include

    function copyHierarchy () {
      mkdir -p $1
      while read f; do
        mkdir -p $1/$(dirname $f)
        cp --parents -pn $f $1
      done
    }

    # Set up our include directories
    (cd ${xnu}/include && find . -name '*.h' -or -name '*.defs' | copyHierarchy $out/include)
    cp ${xnu}/Library/Frameworks/Kernel.framework/Versions/A/Headers/stdarg.h        $out/include

    # These headers are from a newer SDK, but they’re more compatible with GCC (and still work with older SDKs).
    cp ${AvailabilityVersions}/include/Availability*.h $out/include
    cp -r ${AvailabilityVersions}/include/os $out/include
    # But make sure the max version is set correctly for the current SDK.
    # TODO: Make this replacement be independent of SDK version.
    substituteInPlace $out/include/AvailabilityInternal.h \
      --replace-fail '__MAC_OS_X_VERSION_MAX_ALLOWED __MAC_15_0' '__MAC_OS_X_VERSION_MAX_ALLOWED __MAC_10_12_4'
    substituteInPlace $out/include/AvailabilityMacros.h \
      --replace-fail 'MAC_OS_X_VERSION_MIN_REQUIRED > MAC_OS_VERSION_14_0' 'MAC_OS_X_VERSION_MIN_REQUIRED > __MAC_10_12_4' \
      --replace-fail 'MAC_OS_X_VERSION_MAX_ALLOWED MAC_OS_VERSION_14_0' 'MAC_OS_X_VERSION_MAX_ALLOWED __MAC_10_12_4'

    for dep in ${Libc} ${Libm} ${Libinfo} ${dyld} ${architecture} \
               ${libclosure} ${CarbonHeaders} ${libdispatch} \
               ${CommonCrypto} ${copyfile} ${removefile} ${libresolvHeaders} \
               ${Libnotify} ${libplatform} ${mDNSResponder} ${launchd} \
               ${libutilHeaders} ${libmalloc} ${libpthread} ${hfsHeaders}; do
      (cd $dep/include && find . -name '*.h' | copyHierarchy $out/include)
    done

    (cd ${lib.getDev buildPackages.cctools}/include/mach-o && find . -name '*.h' | copyHierarchy $out/include/mach-o)

    for header in pthread.h pthread_impl.h pthread_spis.h sched.h; do
      ln -s "$out/include/pthread/$header" "$out/include/$header"
    done

    # Copy `asl.h` from the syslog sources since it is no longer provided as part of Libc.
    cp ${syslog.src}/libsystem_asl.tproj/include/asl.h $out/include

    mkdir -p $out/include/os

    cp ${darling.src}/src/libc/os/activity.h $out/include/os
    cp ${darling.src}/src/libc/os/log.h $out/include/os
    cp ${darling.src}/src/duct/include/os/trace.h $out/include/os

    cat <<EOF > $out/include/TargetConditionals.h
    #ifndef __TARGETCONDITIONALS__
    #define __TARGETCONDITIONALS__
    #define TARGET_OS_MAC               1
    #define TARGET_OS_WIN32             0
    #define TARGET_OS_UNIX              0
    #define TARGET_OS_OSX               1
    #define TARGET_OS_IPHONE            0
    #define TARGET_OS_IOS               0
    #define TARGET_OS_WATCH             0
    #define TARGET_OS_BRIDGE            0
    #define TARGET_OS_TV                0
    #define TARGET_OS_SIMULATOR         0
    #define TARGET_OS_EMBEDDED          0
    #define TARGET_OS_EMBEDDED_OTHER    0 /* Used in configd */
    #define TARGET_IPHONE_SIMULATOR     TARGET_OS_SIMULATOR /* deprecated */
    #define TARGET_OS_NANO              TARGET_OS_WATCH /* deprecated */
    #define TARGET_OS_LINUX             0

    #define TARGET_CPU_PPC          0
    #define TARGET_CPU_PPC64        0
    #define TARGET_CPU_68K          0
    #define TARGET_CPU_X86          0
    #define TARGET_CPU_X86_64       1
    #define TARGET_CPU_ARM          0
    #define TARGET_CPU_ARM64        0
    #define TARGET_CPU_MIPS         0
    #define TARGET_CPU_SPARC        0
    #define TARGET_CPU_ALPHA        0
    #define TARGET_RT_MAC_CFM       0
    #define TARGET_RT_MAC_MACHO     1
    #define TARGET_RT_LITTLE_ENDIAN 1
    #define TARGET_RT_BIG_ENDIAN    0
    #define TARGET_RT_64_BIT        1
    #endif  /* __TARGETCONDITIONALS__ */
    EOF
  '' + lib.optionalString (!headersOnly) ''
    cp -vr \
      ${darwin-stubs}/usr/lib/libSystem.B.tbd \
      ${darwin-stubs}/usr/lib/system \
      $out/lib

    substituteInPlace $out/lib/libSystem.B.tbd \
      --replace-fail "/usr/lib/system/" "$out/lib/system/"
    ln -s libSystem.B.tbd $out/lib/libSystem.tbd

    # Set up links to pretend we work like a conventional unix (Apple's design, not mine!)
    for name in c dbm dl info m mx poll proc pthread rpcsvc util gcc_s.10.4 gcc_s.10.5; do
      ln -s libSystem.tbd $out/lib/lib$name.tbd
    done
  '' + lib.optionalString withCsu ''
    # The startup object files
    cp ${Csu}/lib/* $out/lib
  '' + lib.optionalString withLibresolv ''
    # This probably doesn't belong here, but we want to stay similar to glibc, which includes resolv internally...
    ln -s ${lib.getLib libresolv}/lib/libresolv.9.dylib $out/lib
    ln -s libresolv.9.dylib $out/lib/libresolv.dylib
  '';

  appleHeaders = builtins.readFile ./headers.txt;

  meta = with lib; {
    description = "The Mac OS libc/libSystem (tapi library with pure headers)";
    maintainers = with maintainers; [ copumpkin gridaphobe ];
    platforms   = platforms.darwin;
    license     = licenses.apple-psl20;
  };
}
