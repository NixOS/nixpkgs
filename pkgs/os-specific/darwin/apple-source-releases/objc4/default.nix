{ appleDerivation, darwin-stubs }:

appleDerivation {
  # Not strictly necessary, since libSystem depends on it, but it's nice to be explicit so we
  # can easily find out what's impure.
  __propagatedImpureHostDeps = [
    "/usr/lib/libauto.dylib"
    "/usr/lib/libc++abi.dylib"
    "/usr/lib/libc++.1.dylib"
    "/usr/lib/libSystem.B.dylib"
  ];

  installPhase = ''
    mkdir -p $out/include/objc $out/lib
    cp ${darwin-stubs}/usr/lib/libobjc.A.tbd $out/lib/libobjc.A.tbd
    ln -s libobjc.A.tbd $out/lib/libobjc.tbd
    cp runtime/OldClasses.subproj/List.h $out/include/objc/List.h
    cp runtime/NSObjCRuntime.h $out/include/objc/NSObjCRuntime.h
    cp runtime/NSObject.h $out/include/objc/NSObject.h
    cp runtime/Object.h $out/include/objc/Object.h
    cp runtime/Protocol.h $out/include/objc/Protocol.h
    cp runtime/hashtable.h $out/include/objc/hashtable.h
    cp runtime/hashtable2.h $out/include/objc/hashtable2.h
    cp runtime/message.h $out/include/objc/message.h
    cp runtime/objc-api.h $out/include/objc/objc-api.h
    cp runtime/objc-auto.h $out/include/objc/objc-auto.h
    cp runtime/objc-class.h $out/include/objc/objc-class.h
    cp runtime/objc-exception.h $out/include/objc/objc-exception.h
    cp runtime/objc-load.h $out/include/objc/objc-load.h
    cp runtime/objc-runtime.h $out/include/objc/objc-runtime.h
    cp runtime/objc-sync.h $out/include/objc/objc-sync.h
    cp runtime/objc.h $out/include/objc/objc.h
    cp runtime/runtime.h $out/include/objc/runtime.h
  '';
}
