{ appleDerivation, xcbuild, libsecurity_keychain, libsecurity_asn1
, libsecurity_cssm, apple_sdk, osx_private_sdk, libsecurity_mds
, xnu, libsecurity_codesigning, libsecurity_authorization, libsecurity_cms
, libsecurity_ssl, CarbonHeaders-full, corecrypto }:

appleDerivation {
  buildInputs = [ xcbuild libsecurity_keychain libsecurity_asn1
                  libsecurity_cssm libsecurity_mds libsecurity_codesigning
                  libsecurity_authorization libsecurity_cms libsecurity_ssl
                  corecrypto ];
  NIX_CFLAGS_COMPILE = "-Iinclude";
  patchPhase = ''
    mkdir -p include/xpc
    cp ${apple_sdk.sdk}/include/xpc/* include/xpc
    cp ${osx_private_sdk}/include/xpc/private.h include/xpc

    substituteInPlace lib/cmssigdata.c \
      --replace "CCRandomRef kCCRandomDevRandom" "const CCRandomRef kCCRandomDevRandom"

    for f in lib/tsaSupport.c lib/cmsutil.c lib/cmssiginfo.c lib/cmsencode.c \
             lib/cmscinfo.c lib/cert.c
    do substituteInPlace $f \
         --replace \
         'CoreServices/../Frameworks/CarbonCore.framework/Headers/MacErrors.h' \
         '${CarbonHeaders-full}/include/MacErrors.h'
    done
  '';
}
