{
  stdenv,
  fetchapplesource,
  libauto,
  launchd,
  libc_old,
  libunwind,
}:

stdenv.mkDerivation rec {
  version = "551.1";
  pname = "objc4";

  src = fetchapplesource {
    inherit version;
    name = "objc4";
    sha256 = "1jrdb6yyb5jwwj27c1r0nr2y2ihqjln8ynj61mpkvp144c1cm5bg";
  };

  patches = [ ./spinlocks.patch ];

  buildInputs = [
    libauto
    launchd
    libc_old
    libunwind
  ];

  buildPhase = ''
    cp ${./objc-probes.h} runtime/objc-probes.h

    mkdir -p build/include/objc

    cp runtime/hashtable.h               build/include/objc/hashtable.h
    cp runtime/OldClasses.subproj/List.h build/include/objc/List.h
    cp runtime/hashtable2.h              build/include/objc/hashtable2.h
    cp runtime/message.h                 build/include/objc/message.h
    cp runtime/objc-api.h                build/include/objc/objc-api.h
    cp runtime/objc-auto.h               build/include/objc/objc-auto.h
    cp runtime/objc-class.h              build/include/objc/objc-class.h
    cp runtime/objc-exception.h          build/include/objc/objc-exception.h
    cp runtime/objc-load.h               build/include/objc/objc-load.h
    cp runtime/objc-sync.h               build/include/objc/objc-sync.h
    cp runtime/objc.h                    build/include/objc/objc.h
    cp runtime/objc-runtime.h            build/include/objc/objc-runtime.h
    cp runtime/Object.h                  build/include/objc/Object.h
    cp runtime/Protocol.h                build/include/objc/Protocol.h
    cp runtime/runtime.h                 build/include/objc/runtime.h
    cp runtime/NSObject.h                build/include/objc/NSObject.h
    cp runtime/NSObjCRuntime.h           build/include/objc/NSObjCRuntime.h

    # These would normally be in local/include but we don't do local, so they're
    # going in with the others
    cp runtime/maptable.h                build/include/objc/maptable.h
    cp runtime/objc-abi.h                build/include/objc/objc-abi.h
    cp runtime/objc-auto-dump.h          build/include/objc/objc-auto-dump.h
    cp runtime/objc-gdb.h                build/include/objc/objc-gdb.h
    cp runtime/objc-internal.h           build/include/objc/objc-internal.h

    cc -o markgc markgc.c

    FLAGS="-Wno-deprecated-register -Wno-unknown-pragmas -Wno-deprecated-objc-isa-usage -Wno-invalid-offsetof -Wno-inline-new-delete  -Wno-cast-of-sel-type -Iruntime -Ibuild/include -Iruntime/Accessors.subproj -D_LIBCPP_VISIBLE= -DOS_OBJECT_USE_OBJC=0 -DNDEBUG=1"

    cc -std=gnu++11 $FLAGS -c runtime/hashtable2.mm
    cc -std=gnu++11 $FLAGS -c runtime/maptable.mm
    cc -std=gnu++11 $FLAGS -c runtime/objc-auto.mm
    cc -std=gnu++11 $FLAGS -c runtime/objc-cache.mm
    cc -std=gnu++11 $FLAGS -c runtime/objc-class-old.mm
    cc -std=gnu++11 $FLAGS -c runtime/objc-class.mm
    cc -std=gnu++11 $FLAGS -c runtime/objc-errors.mm
    cc -std=gnu++11 $FLAGS -c runtime/objc-exception.mm
    cc -std=gnu++11 $FLAGS -c runtime/objc-file.mm
    cc -std=gnu++11 $FLAGS -c runtime/objc-initialize.mm
    cc -std=gnu++11 $FLAGS -c runtime/objc-layout.mm
    cc -std=gnu++11 $FLAGS -c runtime/objc-load.mm
    cc -std=gnu++11 $FLAGS -c runtime/objc-loadmethod.mm
    cc -std=gnu++11 $FLAGS -c runtime/objc-lockdebug.mm
    cc -std=gnu++11 $FLAGS -c runtime/objc-runtime-new.mm
    cc -std=gnu++11 $FLAGS -c runtime/objc-runtime-old.mm
    cc -std=gnu++11 $FLAGS -c runtime/objc-runtime.mm
    cc -std=gnu++11 $FLAGS -c runtime/objc-sel-set.mm
    cc -std=gnu++11 $FLAGS -c runtime/objc-sel.mm
    cc -std=gnu++11 $FLAGS -c runtime/objc-sync.mm
    cc -std=gnu++11 $FLAGS -c runtime/objc-typeencoding.mm
    cc -std=gnu++11 $FLAGS -c runtime/Object.mm
    cc -std=gnu++11 $FLAGS -c runtime/Protocol.mm

    cc -std=gnu++11 $FLAGS -c runtime/objc-references.mm
    cc -std=gnu++11 $FLAGS -c runtime/objc-os.mm
    cc -std=gnu++11 $FLAGS -c runtime/objc-auto-dump.mm
    cc -std=gnu++11 $FLAGS -c runtime/objc-file-old.mm
    cc -std=gnu++11 $FLAGS -c runtime/objc-block-trampolines.mm
    cc -std=gnu++11 $FLAGS -c runtime/objc-externalref.mm
    cc -std=gnu++11 $FLAGS -c runtime/objc-weak.mm
    cc -std=gnu++11 $FLAGS -c runtime/NSObject.mm
    cc -std=gnu++11 $FLAGS -c runtime/objc-opt.mm
    cc -std=gnu++11 $FLAGS -c runtime/objc-cache-old.mm
    cc -std=gnu++11 $FLAGS -c runtime/objc-sel-old.mm

    cc -std=gnu++11 $FLAGS -c runtime/Accessors.subproj/objc-accessors.mm

    cc $FLAGS -c runtime/objc-sel-table.s

    cc $FLAGS -c runtime/OldClasses.subproj/List.m
    cc $FLAGS -c runtime/Messengers.subproj/objc-msg-arm.s
    cc $FLAGS -c runtime/Messengers.subproj/objc-msg-i386.s
    cc $FLAGS -c runtime/Messengers.subproj/objc-msg-x86_64.s
    cc $FLAGS -c runtime/Messengers.subproj/objc-msg-simulator-i386.s

    cc $FLAGS -c runtime/a1a2-blocktramps-i386.s
    cc $FLAGS -c runtime/a2a3-blocktramps-i386.s

    cc $FLAGS -c runtime/a1a2-blocktramps-x86_64.s
    cc $FLAGS -c runtime/a2a3-blocktramps-x86_64.s

    cc $FLAGS -c runtime/a1a2-blocktramps-arm.s
    cc $FLAGS -c runtime/a2a3-blocktramps-arm.s

    c++ -Wl,-no_dtrace_dof --stdlib=libc++ -dynamiclib -lauto -install_name $out/lib/libobjc.dylib -o libobjc.dylib *.o

    ./markgc -p libobjc.dylib
  '';

  installPhase = ''
    mkdir -p $out/include $out/lib

    mv build/include/objc $out/include
    mv libobjc.dylib $out/lib
  '';
}
