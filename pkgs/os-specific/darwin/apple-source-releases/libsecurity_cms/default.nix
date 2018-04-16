{ appleDerivation, libsecurity_cssm, libsecurity_smime, libsecurity_asn1
, libsecurity_keychain, xcbuild, Security, CarbonHeaders-full }:
appleDerivation {
  buildInputs = [ xcbuild libsecurity_cssm libsecurity_asn1 libsecurity_keychain ];
  NIX_CFLAGS_COMPILE = "-I.";
  preBuild = ''
    # break recursive issue
    # libsecurity_cms needs libsecurity_smime but libsecurity_smime needs libsecurity_cms
    mkdir Security
    unpackFile ${libsecurity_smime.src}
    cp -f libsecurity_smime-*/lib/*.h Security
    ln -s Security security_smime
  '';
  patchPhase = ''
    for f in lib/CMSUtils.cpp lib/CMSDecoder.cpp lib/CMSEncoder.cpp
    do substituteInPlace $f \
         --replace \
         'CoreServices/../Frameworks/CarbonCore.framework/Headers/MacErrors.h' \
         '${CarbonHeaders-full}/include/MacErrors.h'
    done
  '';
  installPhase = ''
    mkdir -p $out/Library/Frameworks
    cp -r Products/security_cms.framework $out/Library/Frameworks
    mkdir -p $out/Library/Frameworks/security_cms.framework/Versions/Current
    cp Products/security_cms $out/Library/Frameworks/security_cms.framework/Versions/Current
    cp Products/security_cms_debug_debug $out/Library/Frameworks/security_cms.framework/Versions/Current/security_cms_debug
    mkdir -p $out/Library/Frameworks/security_cms.framework/Headers
    cp lib/*.h $out/Library/Frameworks/security_cms.framework/Headers
    mkdir -p $out/include
    ln -s $out/Library/Frameworks/security_cms.framework/Headers $out/include/security_cms
    ln -s $out/include/security_cms $out/include/Security
  '';
}
