{appleDerivation, xcbuild, osx_private_sdk, apple_sdk, libsecurity_cssm}:
appleDerivation {
  name = "libsecurity_authorization";
  buildInputs = [xcbuild libsecurity_cssm];
  postUnpack = "sourceRoot=\${sourceRoot}/libsecurity_authorization";
  NIX_CFLAGS_COMPILE = "-I../sec -Iinclude";
  patchPhase = ''
    cp lib/*.h ../sec/Security

    # private headers
    mkdir -p include/CoreFoundation
    cp ${osx_private_sdk.src}/PrivateSDK10.10.sparse.sdk/System/Library/Frameworks/CoreFoundation.framework/PrivateHeaders/CFXPCBridge.h include/CoreFoundation
    mkdir -p include/xpc
    cp ${apple_sdk.sdk}/include/xpc/* include/xpc
    cp ${osx_private_sdk}/include/xpc/private.h include/xpc
  '';
  installPhase = ''
    # have no idea why it's called libsecurityd
    install -D Products/Release/libsecurityd.a $out/lib/libsecurity_utilities.a

    mkdir -p $out/include/security_utilities
    cp -r Products/Release/derived_src/security_utilities $out/include/security_utilities
    cp lib/*.h $out/include/security_utilities
    ln -s $out/include/security_utilities $out/include/Security
  '';
}
