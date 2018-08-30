{ appleDerivation, libsecurity_cdsa_utilities, libsecurity_utilities
, Security, xnu, xar, antlr, libsecurityd, apple_sdk
, dtrace-xcode, osx_private_sdk }:
appleDerivation {
  buildInputs = [ libsecurity_utilities libsecurity_cdsa_utilities dtrace-xcode
                  Security xar antlr libsecurityd ];
  NIX_CFLAGS_COMPILE = "-Iinclude -I${xnu}/Library/Frameworks/System.framework/Headers";
  patchPhase = ''
    substituteInPlace lib/policydb.cpp \
      --replace "new MutableDictionary::MutableDictionary()" NULL
    substituteInPlace lib/xpcengine.h \
      --replace "#include <xpc/private.h>" ""
    substituteInPlace lib/policyengine.cpp \
      --replace "#include <OpenScriptingUtilPriv.h>" ""

    rm lib/policyengine.cpp lib/quarantine++.cpp lib/codedirectory.cpp lib/xpcengine.cpp
  '';
  preBuild = ''
    mkdir -p include
    cp ${osx_private_sdk.src}/PrivateSDK10.10.sparse.sdk/usr/include/quarantine.h include
    mkdir -p include/CoreServices/
    cp ${osx_private_sdk.src}/PrivateSDK10.10.sparse.sdk/System/Library/Frameworks/CoreServices.framework/PrivateHeaders/*.h include/CoreServices/

    unpackFile ${Security.src}
    mkdir -p include/securityd_client
    cp Security-*/libsecurityd/lib/*.h include/securityd_client
    mkdir -p include/xpc
    cp ${apple_sdk.sdk.out}/include/xpc/*.h include/xpc

    sed -i '1i #define bool int' lib/security_codesigning.d
    dtrace -h -C -s lib/security_codesigning.d -o codesigning_dtrace.h
  '';
}
