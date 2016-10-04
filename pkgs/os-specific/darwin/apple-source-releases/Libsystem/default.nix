{ stdenv, appleDerivation, cpio, bootstrap_cmds, xnu, Libc, Libm, libdispatch, cctools, Libinfo,
  dyld, Csu, architecture, libclosure, CarbonHeaders, ncurses, CommonCrypto, copyfile,
  removefile, libresolv, Libnotify, libpthread, mDNSResponder, launchd, libutil, version }:

appleDerivation rec {
  phases = [ "unpackPhase" "installPhase" ];

  buildInputs = [ cpio ];

  installPhase = ''
    export NIX_ENFORCE_PURITY=

    mkdir -p $out/lib $out/include

    # Set up our include directories
    (cd ${xnu}/include && find . -name '*.h' -or -name '*.defs' | cpio -pdm $out/include)
    cp ${xnu}/Library/Frameworks/Kernel.framework/Versions/A/Headers/Availability*.h $out/include
    cp ${xnu}/Library/Frameworks/Kernel.framework/Versions/A/Headers/stdarg.h        $out/include

    for dep in ${Libc} ${Libm} ${Libinfo} ${dyld} ${architecture} ${libclosure} ${CarbonHeaders} \
               ${libdispatch} ${ncurses.dev} ${CommonCrypto} ${copyfile} ${removefile} ${libresolv} \
               ${Libnotify} ${mDNSResponder} ${launchd} ${libutil} ${libpthread}; do
      (cd $dep/include && find . -name '*.h' | cpio -pdm $out/include)
    done

    (cd ${cctools}/include/mach-o && find . -name '*.h' | cpio -pdm $out/include/mach-o)

    cat <<EOF > $out/include/TargetConditionals.h
    #ifndef __TARGETCONDITIONALS__
    #define __TARGETCONDITIONALS__
    #define TARGET_OS_MAC           1
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

    # OMG impurity
    ln -s /usr/lib/libSystem.B.dylib $out/lib/libSystem.B.dylib
    ln -s /usr/lib/libSystem.dylib $out/lib/libSystem.dylib

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
      -delete_rpath ${libresolv}/lib \
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
