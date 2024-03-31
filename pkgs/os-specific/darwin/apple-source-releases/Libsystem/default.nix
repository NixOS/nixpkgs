{ lib, stdenv, buildPackages, fetchzip, fetchFromGitHub
, appleDerivation', xnu, Libc, Libm, libdispatch, Libinfo
, dyld, Csu, architecture, libclosure, CarbonHeaders, ncurses, CommonCrypto
, copyfile, removefile, libresolvHeaders, libresolv, Libnotify, libmalloc, libplatform, libpthread
, mDNSResponder, launchd, libutilHeaders, hfsHeaders, darwin-stubs
, headersOnly ? false
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
appleDerivation' stdenv {
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
    cp ${xnu}/Library/Frameworks/Kernel.framework/Versions/A/Headers/Availability*.h $out/include
    cp ${xnu}/Library/Frameworks/Kernel.framework/Versions/A/Headers/stdarg.h        $out/include

    for dep in ${Libc} ${Libm} ${Libinfo} ${dyld} ${architecture} \
               ${libclosure} ${CarbonHeaders} ${libdispatch} ${ncurses.dev} \
               ${CommonCrypto} ${copyfile} ${removefile} ${libresolvHeaders} \
               ${Libnotify} ${libplatform} ${mDNSResponder} ${launchd} \
               ${libutilHeaders} ${libmalloc} ${libpthread} ${hfsHeaders}; do
      (cd $dep/include && find . -name '*.h' | copyHierarchy $out/include)
    done

    (cd ${buildPackages.darwin.cctools.dev}/include/mach-o && find . -name '*.h' | copyHierarchy $out/include/mach-o)

    for header in pthread.h pthread_impl.h pthread_spis.h sched.h; do
      ln -s "$out/include/pthread/$header" "$out/include/$header"
    done

    # Copy `asl.h` from the syslog sources since it is no longer provided as part of Libc.
    cp ${syslog.src}/libsystem_asl.tproj/include/asl.h $out/include

    mkdir -p $out/include/os

    cp ${darling.src}/src/libc/os/activity.h $out/include/os
    cp ${darling.src}/src/libc/os/log.h $out/include/os
    cp ${darling.src}/src/duct/include/os/trace.h $out/include/os

    cat <<EOF > $out/include/os/availability.h
    #ifndef __OS_AVAILABILITY__
    #define __OS_AVAILABILITY__
    #include <AvailabilityInternal.h>

    #if defined(__has_feature) && defined(__has_attribute) && __has_attribute(availability)
      #define API_AVAILABLE(...) __API_AVAILABLE_GET_MACRO(__VA_ARGS__, __API_AVAILABLE4, __API_AVAILABLE3, __API_AVAILABLE2, __API_AVAILABLE1)(__VA_ARGS__)
      #define API_DEPRECATED(...) __API_DEPRECATED_MSG_GET_MACRO(__VA_ARGS__, __API_DEPRECATED_MSG5, __API_DEPRECATED_MSG4, __API_DEPRECATED_MSG3, __API_DEPRECATED_MSG2, __API_DEPRECATED_MSG1)(__VA_ARGS__)
      #define API_DEPRECATED_WITH_REPLACEMENT(...) __API_DEPRECATED_REP_GET_MACRO(__VA_ARGS__, __API_DEPRECATED_REP5, __API_DEPRECATED_REP4, __API_DEPRECATED_REP3, __API_DEPRECATED_REP2, __API_DEPRECATED_REP1)(__VA_ARGS__)
      #define API_UNAVAILABLE(...) __API_UNAVAILABLE_GET_MACRO(__VA_ARGS__, __API_UNAVAILABLE3, __API_UNAVAILABLE2, __API_UNAVAILABLE1)(__VA_ARGS__)
    #else

      #define API_AVAILABLE(...)
      #define API_DEPRECATED(...)
      #define API_DEPRECATED_WITH_REPLACEMENT(...)
      #define API_UNAVAILABLE(...)

    #endif
    #endif
    EOF

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

    # The startup object files
    cp ${Csu}/lib/* $out/lib

    cp -vr \
      ${darwin-stubs}/usr/lib/libSystem.B.tbd \
      ${darwin-stubs}/usr/lib/system \
      $out/lib

    substituteInPlace $out/lib/libSystem.B.tbd \
      --replace "/usr/lib/system/" "$out/lib/system/"
    ln -s libSystem.B.tbd $out/lib/libSystem.tbd

    # Set up links to pretend we work like a conventional unix (Apple's design, not mine!)
    for name in c dbm dl info m mx poll proc pthread rpcsvc util gcc_s.10.4 gcc_s.10.5; do
      ln -s libSystem.tbd $out/lib/lib$name.tbd
    done
  '' + lib.optionalString withLibresolv ''

    # This probably doesn't belong here, but we want to stay similar to glibc, which includes resolv internally...
    cp ${libresolv}/lib/libresolv.9.dylib $out/lib/libresolv.9.dylib
    resolv_libSystem=$(${stdenv.cc.bintools.targetPrefix}otool -L "$out/lib/libresolv.9.dylib" | tail -n +3 | grep -o "$NIX_STORE.*-\S*") || true
    echo $libs

    chmod +w $out/lib/libresolv.9.dylib
    ${stdenv.cc.bintools.targetPrefix}install_name_tool \
      -id $out/lib/libresolv.9.dylib \
      -change "$resolv_libSystem" /usr/lib/libSystem.dylib \
      $out/lib/libresolv.9.dylib
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
