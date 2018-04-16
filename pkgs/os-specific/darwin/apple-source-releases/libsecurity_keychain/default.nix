{ CF, Security, appleDerivation, apple_sdk, libsecurity_asn1
, libsecurity_cdsa_client, libsecurity_cdsa_utilities
, libsecurity_cdsa_utils, libsecurity_ocspd, libsecurity_pkcs12
, libsecurity_utilities, libsecurityd, openssl, libsecurity_mds
, osx_private_sdk, security_dotmac_tp, CarbonHeaders-full }:
appleDerivation {
  buildInputs = [
    libsecurity_utilities
    libsecurity_cdsa_client
    libsecurity_cdsa_utilities
    libsecurityd
    CF
    libsecurity_asn1
    libsecurity_pkcs12
    libsecurity_cdsa_utils
    openssl
    libsecurity_ocspd
    security_dotmac_tp
  ];
  propagatedBuildInputs = [ libsecurity_mds ];
  patchPhase = ''
    substituteInPlace lib/Keychains.cpp --replace DLDbListCFPref.h DLDBListCFPref.h

    substituteInPlace lib/SecCertificate.cpp --replace '#include <Security/SecCertificatePriv.h>' ""

    cp ${osx_private_sdk}/include/xpc/private.h xpc
    cp ${apple_sdk.sdk}/include/xpc/*.h xpc
    cp ${osx_private_sdk}/include/sandbox_private.h lib/sandbox.h

    substituteInPlace lib/SecItemPriv.h \
      --replace "extern CFTypeRef kSecAttrAccessGroup" "extern const CFTypeRef kSecAttrAccessGroup" \
      --replace "extern CFTypeRef kSecAttrIsSensitive" "extern const CFTypeRef kSecAttrIsSensitive" \
      --replace "extern CFTypeRef kSecAttrIsExtractable" "extern const CFTypeRef kSecAttrIsExtractable"

    substituteInPlace lib/Keychains.cpp --replace \
      '<CoreServices/../Frameworks/CarbonCore.framework/Headers/MacErrors.h>' \
      '"${CarbonHeaders-full}/include/MacErrors.h"'

    substituteInPlace lib/CertificateValues.cpp --replace \
      '#include <Security/SecCertificatePriv.h>' ""

    substituteInPlace lib/DLDBListCFPref.cpp --replace \
      'dispatch_once_t AppSandboxChecked;' ''$'namespace Security {\ndispatch_once_t AppSandboxChecked;' \
      --replace 'return mLoginDLDbIdentifier;' 'return mLoginDLDbIdentifier; }' \
      --replace '_xpc_runtime_is_app_sandboxed()' 'false'
      # hope that doesn't hurt anything

    substituteInPlace lib/KCEventNotifier.h --replace \
      'CoreFoundation/CFNotificationCenter.h' \
      '${apple_sdk.sdk}/Library/Frameworks/CoreFoundation.framework/Versions/A/Headers/CFNotificationCenter.h'
  '';

  postInstall = ''
    ln -s $out/include/security_keychain $out/include/Security
  '';
}
