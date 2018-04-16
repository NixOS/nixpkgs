{ appleDerivation, libsecurity_cdsa_utilities, libsecurity_utilities, libsecurityd, osx_private_sdk }:
appleDerivation {
  buildInputs = [
    libsecurity_utilities
    libsecurity_cdsa_utilities
    libsecurityd
  ];
  postInstall = ''
    mkdir -p $out/include/Security
    cp -Lf ${osx_private_sdk.src}/PrivateSDK10.10.sparse.sdk/System/Library/Frameworks/Security.framework/PrivateHeaders/mdspriv.h $out/include/Security
  '';
}
