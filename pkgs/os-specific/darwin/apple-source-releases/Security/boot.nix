{ appleDerivation', stdenv, darwin-stubs }:

appleDerivation' stdenv {
  __propagatedImpureHostDeps = [
    "/System/Library/Frameworks/Security.framework/Security"
    "/System/Library/Frameworks/Security.framework/Resources"
    "/System/Library/Frameworks/Security.framework/PlugIns"
    "/System/Library/Frameworks/Security.framework/XPCServices"
    "/System/Library/Frameworks/Security.framework/Versions"
  ];

  installPhase = ''
    mkdir -p $out/Library/Frameworks/Security.framework

    ###### IMPURITIES
    ln -s /System/Library/Frameworks/Security.framework/{Resources,Plugins,XPCServices} \
      $out/Library/Frameworks/Security.framework

    ###### STUBS
    cp ${darwin-stubs}/System/Library/Frameworks/Security.framework/Versions/A/Security.tbd \
      $out/Library/Frameworks/Security.framework

    ###### HEADERS

    export dest=$out/Library/Frameworks/Security.framework/Headers
    mkdir -p $dest

    cp libsecurity_asn1/lib/SecAsn1Coder.h     $dest
    cp libsecurity_asn1/lib/SecAsn1Templates.h $dest
    cp libsecurity_asn1/lib/SecAsn1Types.h     $dest
    cp libsecurity_asn1/lib/oidsalg.h          $dest
    cp libsecurity_asn1/lib/oidsattr.h         $dest

    cp libsecurity_authorization/lib/AuthSession.h         $dest
    cp libsecurity_authorization/lib/Authorization.h       $dest
    cp libsecurity_authorization/lib/AuthorizationDB.h     $dest
    cp libsecurity_authorization/lib/AuthorizationPlugin.h $dest
    cp libsecurity_authorization/lib/AuthorizationTags.h   $dest

    cp libsecurity_cms/lib/CMSDecoder.h $dest
    cp libsecurity_cms/lib/CMSEncoder.h $dest

    cp libsecurity_codesigning/lib/CSCommon.h       $dest
    cp libsecurity_codesigning/lib/CodeSigning.h    $dest
    cp libsecurity_codesigning/lib/SecCode.h        $dest
    cp libsecurity_codesigning/lib/SecCodeHost.h    $dest
    cp libsecurity_codesigning/lib/SecRequirement.h $dest
    cp libsecurity_codesigning/lib/SecStaticCode.h  $dest
    cp libsecurity_codesigning/lib/SecTask.h        $dest

    cp libsecurity_cssm/lib/certextensions.h $dest
    cp libsecurity_cssm/lib/cssm.h           $dest
    cp libsecurity_cssm/lib/cssmaci.h        $dest
    cp libsecurity_cssm/lib/cssmapi.h        $dest
    cp libsecurity_cssm/lib/cssmapple.h      $dest
    cp libsecurity_cssm/lib/cssmcli.h        $dest
    cp libsecurity_cssm/lib/cssmconfig.h     $dest
    cp libsecurity_cssm/lib/cssmcspi.h       $dest
    cp libsecurity_cssm/lib/cssmdli.h        $dest
    cp libsecurity_cssm/lib/cssmerr.h        $dest
    cp libsecurity_cssm/lib/cssmkrapi.h      $dest
    cp libsecurity_cssm/lib/cssmkrspi.h      $dest
    cp libsecurity_cssm/lib/cssmspi.h        $dest
    cp libsecurity_cssm/lib/cssmtpi.h        $dest
    cp libsecurity_cssm/lib/cssmtype.h       $dest
    cp libsecurity_cssm/lib/eisl.h           $dest
    cp libsecurity_cssm/lib/emmspi.h         $dest
    cp libsecurity_cssm/lib/emmtype.h        $dest
    cp libsecurity_cssm/lib/oidsbase.h       $dest
    cp libsecurity_cssm/lib/oidscert.h       $dest
    cp libsecurity_cssm/lib/oidscrl.h        $dest
    cp libsecurity_cssm/lib/x509defs.h       $dest

    cp libsecurity_keychain/lib/SecACL.h                $dest
    cp libsecurity_keychain/lib/SecAccess.h             $dest
    cp libsecurity_keychain/lib/SecBase.h               $dest
    cp libsecurity_keychain/lib/SecCertificate.h        $dest
    cp libsecurity_keychain/lib/SecCertificatePriv.h    $dest # Private
    cp libsecurity_keychain/lib/SecCertificateOIDs.h    $dest
    cp libsecurity_keychain/lib/SecIdentity.h           $dest
    cp libsecurity_keychain/lib/SecIdentitySearch.h     $dest
    cp libsecurity_keychain/lib/SecImportExport.h       $dest
    cp libsecurity_keychain/lib/SecItem.h               $dest
    cp libsecurity_keychain/lib/SecKey.h                $dest
    cp libsecurity_keychain/lib/SecKeychain.h           $dest
    cp libsecurity_keychain/lib/SecKeychainItem.h       $dest
    cp libsecurity_keychain/lib/SecKeychainSearch.h     $dest
    cp libsecurity_keychain/lib/SecPolicy.h             $dest
    cp libsecurity_keychain/lib/SecPolicySearch.h       $dest
    cp libsecurity_keychain/lib/SecRandom.h             $dest
    cp libsecurity_keychain/lib/SecTrust.h              $dest
    cp libsecurity_keychain/lib/SecTrustSettings.h      $dest
    cp libsecurity_keychain/lib/SecTrustedApplication.h $dest
    cp libsecurity_keychain/lib/Security.h              $dest

    cp libsecurity_manifest/lib/SecureDownload.h $dest

    cp libsecurity_mds/lib/mds.h        $dest
    cp libsecurity_mds/lib/mds_schema.h $dest

    cp libsecurity_ssl/lib/CipherSuite.h     $dest
    cp libsecurity_ssl/lib/SecureTransport.h $dest

    cp libsecurity_transform/lib/SecCustomTransform.h        $dest
    cp libsecurity_transform/lib/SecDecodeTransform.h        $dest
    cp libsecurity_transform/lib/SecDigestTransform.h        $dest
    cp libsecurity_transform/lib/SecEncodeTransform.h        $dest
    cp libsecurity_transform/lib/SecEncryptTransform.h       $dest
    cp libsecurity_transform/lib/SecReadTransform.h          $dest
    cp libsecurity_transform/lib/SecSignVerifyTransform.h    $dest
    cp libsecurity_transform/lib/SecTransform.h              $dest
    cp libsecurity_transform/lib/SecTransformReadTransform.h $dest

  '';
}
