{ appleDerivation, xcbuild, Security
, libsecurity_codesigning, libsecurity_utilities, libsecurity_cdsa_utilities
, xnu, osx_private_sdk, pcsclite}:

appleDerivation {
  buildInputs = [ xcbuild Security libsecurity_utilities
                  libsecurity_cdsa_utilities libsecurity_codesigning
                  pcsclite ];

  NIX_LDFLAGS = "-lpcsclite";

  # can't build the whole thing
  xcbuildFlags = "-target codesign";

  preBuild = ''
    mkdir -p include/Security
    cp ${osx_private_sdk.src}/PrivateSDK10.10.sparse.sdk/System/Library/Frameworks/Security.framework/PrivateHeaders/*.h include/Security
    cp ${osx_private_sdk.src}/PrivateSDK10.10.sparse.sdk/System/Library/Frameworks/Security.framework/Headers/*.h include/Security

    unpackFile ${xnu.src}
    mkdir -p include/sys
    cp -r xnu-*/bsd/sys/codesign.h include/sys/codesign.h
  '';

  NIX_CFLAGS_COMPILE = "-Iinclude";

  installPhase = ''
    mkdir -p $out/bin
    cp Products/Release/codesign $out/bin/codesign
  '';
}
