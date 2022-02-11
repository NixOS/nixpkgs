{ appleDerivation, xcbuildHook, xpc, dtrace, xnu }:

appleDerivation {
  nativeBuildInputs = [ xcbuildHook dtrace ];
  # buildInputs = [ Foundation xpc darling ];
  buildInputs = [ xpc xnu ];

  xcbuildFlags = [ "-target" "Security_frameworks_osx" ];

  # NIX_CFLAGS_COMPILE = "-Wno-error -I${xnu}/include/libkern -DPRIVATE -I${xnu}/Library/Frameworks/System.framework/Headers";

  preBuild = ''
    dtrace -h -C -s OSX/libsecurity_utilities/lib/security_utilities.d -o OSX/libsecurity_utilities/lib/utilities_dtrace.h

    xcodebuild SYMROOT=$PWD/Products OBJROOT=$PWD/Intermediates -target copyHeadersToSystem
    NIX_CFLAGS_COMPILE+=" -F./Products/Release"
    ln -s $PWD/Products/Release/Security.bundle/Contents $PWD/Products/Release/Security.framework
  '';
}
