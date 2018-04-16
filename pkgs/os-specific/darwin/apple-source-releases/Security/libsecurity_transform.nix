{ appleDerivation, xcbuild, apple_sdk, osx_private_sdk, libsecurity_keychain
, xnu, libsecurity_cssm, corecrypto, zlib }:
appleDerivation {
  name = "libsecurity_transform";
  buildInputs = [ xcbuild libsecurity_keychain libsecurity_cssm
                  corecrypto apple_sdk.frameworks.CoreServices
                  zlib ];
  postUnpack = "sourceRoot=\${sourceRoot}/libsecurity_transform";
  NIX_CFLAGS_COMPILE = "-Iinclude -Wno-error -framework CoreServices";
  NIX_LDFLAGS = "-framework CoreServices";
  preBuild = ''
    mkdir -p include/xpc
    cp ${apple_sdk.sdk}/include/xpc/* include/xpc
    cp ${osx_private_sdk}/include/xpc/private.h include/xpc
    mkdir -p include/Security
    cp lib/*.h include/Security
  '';
  patchPhase = ''
    substituteInPlace libsecurity_transform.xcodeproj/project.pbxproj \
      --replace \
		    "{isa = PBXFileReference; explicitFileType = archive.ar; path = libsecurity_transform.a; sourceTree = BUILT_PRODUCTS_DIR; };" \
		    "{isa = PBXFileReference; explicitFileType = compiled.mach-o.dylib; path = libsecurity_transform.dylib; sourceTree = BUILT_PRODUCTS_DIR; };"
  '';
}
