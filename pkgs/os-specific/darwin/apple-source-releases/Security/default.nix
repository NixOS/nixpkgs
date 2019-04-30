{ appleDerivation }:

appleDerivation {
  phases = [ "unpackPhase" "installPhase" ];

  __propagatedImpureHostDeps = [
    "/System/Library/Frameworks/Security.framework/Security"
    "/System/Library/Frameworks/Security.framework/Resources"
    "/System/Library/Frameworks/Security.framework/PlugIns"
    "/System/Library/Frameworks/Security.framework/XPCServices"
    "/System/Library/Frameworks/Security.framework/Versions"
  ];

  installPhase = ''
    ###### IMPURITIES
    mkdir -p $out/Library/Frameworks/Security.framework
    pushd $out/Library/Frameworks/Security.framework
    ln -s /System/Library/Frameworks/Security.framework/Security
    ln -s /System/Library/Frameworks/Security.framework/Resources
    ln -s /System/Library/Frameworks/Security.framework/PlugIns
    ln -s /System/Library/Frameworks/Security.framework/XPCServices
    popd

    ###### HEADERS

    export dest=$out/Library/Frameworks/Security.framework/Headers
    mkdir -p $dest

    set -x

    ls

    cp OSX/libsecurity_asn1/lib/SecAsn1Coder.h     $dest
    cp OSX/libsecurity_asn1/lib/SecAsn1Templates.h $dest
    cp OSX/libsecurity_asn1/lib/SecAsn1Types.h     $dest
    cp OSX/libsecurity_asn1/lib/oidsalg.h          $dest
    cp OSX/libsecurity_asn1/lib/oidsattr.h         $dest

    cp OSX/libsecurity_authorization/lib/AuthSession.h         $dest
    cp OSX/libsecurity_authorization/lib/Authorization.h       $dest
    cp OSX/libsecurity_authorization/lib/AuthorizationDB.h     $dest
    cp OSX/libsecurity_authorization/lib/AuthorizationPlugin.h $dest
    cp OSX/libsecurity_authorization/lib/AuthorizationTags.h   $dest

    cp OSX/libsecurity_cms/lib/CMSDecoder.h $dest
    cp OSX/libsecurity_cms/lib/CMSEncoder.h $dest

    cp OSX/libsecurity_codesigning/lib/CSCommon.h       $dest
    cp OSX/libsecurity_codesigning/lib/CodeSigning.h    $dest
    cp OSX/libsecurity_codesigning/lib/SecCode.h        $dest
    cp OSX/libsecurity_codesigning/lib/SecCodeHost.h    $dest
    cp OSX/libsecurity_codesigning/lib/SecRequirement.h $dest
    cp OSX/libsecurity_codesigning/lib/SecStaticCode.h  $dest
    # TODO(burke): removed in 10.14.1. Is there an equivalent?
    # cp OSX/libsecurity_codesigning/lib/SecTask.h        $dest

    # TODO(burke): removed in 10.14.1. Is there an equivalent?
    # cp OSX/libsecurity_cssm/lib/certextensions.h $dest
    cp OSX/libsecurity_cssm/lib/cssm.h           $dest
    cp OSX/libsecurity_cssm/lib/cssmaci.h        $dest
    cp OSX/libsecurity_cssm/lib/cssmapi.h        $dest
    cp OSX/libsecurity_cssm/lib/cssmapplePriv.h  $dest # Private
    cp OSX/libsecurity_cssm/lib/cssmcli.h        $dest
    cp OSX/libsecurity_cssm/lib/cssmconfig.h     $dest
    cp OSX/libsecurity_cssm/lib/cssmcspi.h       $dest
    cp OSX/libsecurity_cssm/lib/cssmdli.h        $dest
    cp OSX/libsecurity_cssm/lib/cssmerr.h        $dest
    cp OSX/libsecurity_cssm/lib/cssmkrapi.h      $dest
    cp OSX/libsecurity_cssm/lib/cssmkrspi.h      $dest
    cp OSX/libsecurity_cssm/lib/cssmspi.h        $dest
    cp OSX/libsecurity_cssm/lib/cssmtpi.h        $dest
    cp OSX/libsecurity_cssm/lib/cssmtype.h       $dest
    cp OSX/libsecurity_cssm/lib/eisl.h           $dest
    cp OSX/libsecurity_cssm/lib/emmspi.h         $dest
    cp OSX/libsecurity_cssm/lib/emmtype.h        $dest
    cp OSX/libsecurity_cssm/lib/oidsbase.h       $dest
    cp OSX/libsecurity_cssm/lib/oidscert.h       $dest
    cp OSX/libsecurity_cssm/lib/oidscrl.h        $dest
    cp OSX/libsecurity_cssm/lib/x509defs.h       $dest

    cp OSX/libsecurity_keychain/lib/SecACL.h                $dest
    cp OSX/libsecurity_keychain/lib/SecAccess.h             $dest
    cp OSX/libsecurity_keychain/lib/SecBase64P.h            $dest
    cp OSX/libsecurity_keychain/lib/SecCertificate.h        $dest
    cp OSX/libsecurity_keychain/lib/SecCertificatePriv.h    $dest # Private
    cp OSX/libsecurity_keychain/lib/SecCertificateOIDs.h    $dest
    cp OSX/libsecurity_keychain/lib/SecIdentity.h           $dest
    cp OSX/libsecurity_keychain/lib/SecIdentitySearch.h     $dest
    cp OSX/libsecurity_keychain/lib/SecImportExport.h       $dest
    cp OSX/libsecurity_keychain/lib/SecItem.h               $dest
    cp OSX/libsecurity_keychain/lib/SecKey.h                $dest
    cp OSX/libsecurity_keychain/lib/SecKeychain.h           $dest
    cp OSX/libsecurity_keychain/lib/SecKeychainItem.h       $dest
    cp OSX/libsecurity_keychain/lib/SecKeychainSearch.h     $dest
    cp OSX/libsecurity_keychain/lib/SecPolicy.h             $dest
    cp OSX/libsecurity_keychain/lib/SecPolicySearch.h       $dest
    cp OSX/libsecurity_keychain/lib/SecRandom.h             $dest
    cp OSX/libsecurity_keychain/lib/SecTrust.h              $dest
    cp OSX/libsecurity_keychain/lib/SecTrustSettings.h      $dest
    cp OSX/libsecurity_keychain/lib/SecTrustedApplication.h $dest
    cp OSX/libsecurity_keychain/lib/Security.h              $dest

    cp OSX/libsecurity_manifest/lib/SecureDownload.h $dest

    cp OSX/libsecurity_mds/lib/mds.h        $dest
    cp OSX/libsecurity_mds/lib/mds_schema.h $dest

    cp OSX/libsecurity_ssl/lib/CipherSuite.h     $dest
    cp OSX/libsecurity_ssl/lib/SecureTransport.h $dest

    cp OSX/libsecurity_transform/lib/SecCustomTransform.h        $dest
    cp OSX/libsecurity_transform/lib/SecDecodeTransform.h        $dest
    cp OSX/libsecurity_transform/lib/SecDigestTransform.h        $dest
    cp OSX/libsecurity_transform/lib/SecEncodeTransform.h        $dest
    cp OSX/libsecurity_transform/lib/SecEncryptTransform.h       $dest
    cp OSX/libsecurity_transform/lib/SecReadTransform.h          $dest
    cp OSX/libsecurity_transform/lib/SecSignVerifyTransform.h    $dest
    cp OSX/libsecurity_transform/lib/SecTransform.h              $dest
    cp OSX/libsecurity_transform/lib/SecTransformReadTransform.h $dest

  '';
}
