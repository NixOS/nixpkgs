{ stdenv, appleDerivation, cpio, xnu, Libc, Libm, libdispatch, cctools, Libinfo
, dyld, Csu, architecture, libclosure, CarbonHeaders, ncurses, CommonCrypto
, copyfile, removefile, libresolv, Libnotify, libplatform, libpthread
, mDNSResponder, launchd, libutil, hfs, darling }:

appleDerivation rec {
  dontBuild = true;
  dontFixup = true;

  nativeBuildInputs = [ cpio ];

  installPhase = ''
    export NIX_ENFORCE_PURITY=

    mkdir -p $out/lib $out/include

    # Set up our include directories
    (cd ${xnu}/include && find . -name '*.h' -or -name '*.defs' | cpio -pdm $out/include)
    cp ${xnu}/Library/Frameworks/Kernel.framework/Versions/A/Headers/Availability*.h $out/include
    cp ${xnu}/Library/Frameworks/Kernel.framework/Versions/A/Headers/stdarg.h        $out/include

    for dep in ${Libc} ${Libm} ${Libinfo} ${dyld} ${architecture} \
               ${libclosure} ${CarbonHeaders} ${libdispatch} ${ncurses.dev} \
               ${CommonCrypto} ${copyfile} ${removefile} ${libresolv} \
               ${Libnotify} ${libplatform} ${mDNSResponder} ${launchd} \
               ${libutil} ${libpthread} ${hfs}; do
      (cd $dep/include && find . -name '*.h' | cpio -pdm $out/include)
    done

    (cd ${cctools.dev}/include/mach-o && find . -name '*.h' | cpio -pdm $out/include/mach-o)

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
    #define TARGET_OS_MAC           1
    #define TARGET_OS_OSX           1
    #define TARGET_OS_WIN32         0
    #define TARGET_OS_UNIX          0
    #define TARGET_OS_EMBEDDED      0
    #define TARGET_OS_IPHONE        0
    #define TARGET_IPHONE_SIMULATOR 0
    #define TARGET_OS_LINUX         0

    #define TARGET_CPU_PPC          0
    #define TARGET_CPU_PPC64        0
    #define TARGET_CPU_68K          0
    #define TARGET_CPU_X86          0
    #define TARGET_CPU_X86_64       1
    #define TARGET_CPU_ARM          0
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

    # The startup object files
    cp ${Csu}/lib/* $out/lib

    # We can't re-exported libsystem_c and libsystem_kernel directly,
    # so we link against the central library here.
    mkdir -p $out/lib/system
    ld -macosx_version_min 10.7 -arch x86_64 -dylib \
       -o $out/lib/system/libsystem_c.dylib \
       /usr/lib/libSystem.dylib \
       -reexported_symbols_list ${./system_c_symbols}

    ld -macosx_version_min 10.7 -arch x86_64 -dylib \
       -o $out/lib/system/libsystem_kernel.dylib \
       /usr/lib/libSystem.dylib \
       -reexported_symbols_list ${./system_kernel_symbols}

    # The umbrella libSystem also exports some symbols,
    # but we don't want to pull in everything from the other libraries.
    ld -macosx_version_min 10.7 -arch x86_64 -dylib \
       -o $out/lib/libSystem_internal.dylib \
       /usr/lib/libSystem.dylib \
       -reexported_symbols_list ${./system_symbols}

    # We used to determine these impurely based on the host system, but then when we got some 10.12 Hydra boxes,
    # one of them accidentally built this derivation, referenced libsystem_symptoms.dylib, which doesn't exist on
    # 10.11, and then broke all subsequent builds on 10.11. By picking a 10.11 compatible subset of the libraries,
    # we avoid scary impurity issues like that.
    libs=$(cat ${./reexported_libraries} | grep -v '^#')

    for i in $libs; do
      if [ "$i" != "/usr/lib/system/libsystem_kernel.dylib" ] && [ "$i" != "/usr/lib/system/libsystem_c.dylib" ]; then
        args="$args -reexport_library $i"
      fi
    done

    ld -macosx_version_min 10.7 -arch x86_64 -dylib \
       -o $out/lib/libSystem.B.dylib \
       -compatibility_version 1.0 \
       -current_version 1226.10.1 \
       -reexport_library $out/lib/system/libsystem_c.dylib \
       -reexport_library $out/lib/system/libsystem_kernel.dylib \
       -reexport_library $out/lib/libSystem_internal.dylib \
       $args

    ln -s libSystem.B.dylib $out/lib/libSystem.dylib

    # Set up links to pretend we work like a conventional unix (Apple's design, not mine!)
    for name in c dbm dl info m mx poll proc pthread rpcsvc util gcc_s.10.4 gcc_s.10.5; do
      ln -s libSystem.dylib $out/lib/lib$name.dylib
    done

    # This probably doesn't belong here, but we want to stay similar to glibc, which includes resolv internally...
    cp ${libresolv}/lib/libresolv.9.dylib $out/lib/libresolv.9.dylib
    resolv_libSystem=$(otool -L "$out/lib/libresolv.9.dylib" | tail -n +3 | grep -o "$NIX_STORE.*-\S*") || true
    echo $libs

    chmod +w $out/lib/libresolv.9.dylib
    install_name_tool \
      -id $out/lib/libresolv.9.dylib \
      -change "$resolv_libSystem" $out/lib/libSystem.dylib \
      $out/lib/libresolv.9.dylib
    ln -s libresolv.9.dylib $out/lib/libresolv.dylib
  '';

  meta = with stdenv.lib; {
    description = "The Mac OS libc/libSystem (impure symlinks to binaries with pure headers)";
    maintainers = with maintainers; [ copumpkin gridaphobe ];
    platforms   = platforms.darwin;
    license     = licenses.apsl20;
  };
}
