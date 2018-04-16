{ appleDerivation, xcbuild, libsecurity_keychain, libsecurity_cssm, apple_sdk
, CarbonHeaders-full, libsecurity_utilities, libsecurity_asn1
, libsecurity_mds, libsecurity_codesigning, libsecurity_authorization
, libsecurity_cms }:
appleDerivation {
  buildInputs = [ xcbuild libsecurity_keychain libsecurity_cssm
                  libsecurity_utilities libsecurity_asn1
                  libsecurity_mds libsecurity_codesigning
                  libsecurity_authorization libsecurity_cms ];
  patchPhase = ''
    for f in lib/ssl.h lib/tls_hmac.c lib/sslTransport.c lib/symCipher.c \
             lib/sslKeychain.c lib/sslMemory.c lib/sslContext.c
    do substituteInPlace $f \
         --replace \
         'CoreServices/../Frameworks/CarbonCore.framework/Headers/MacErrors.h' \
         '${CarbonHeaders-full}/include/MacErrors.h'
    done
  '';
}
