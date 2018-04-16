{ appleDerivation, libsecurity_cdsa_client, libsecurity_cdsa_plugin
, libsecurity_cdsa_utilities, libsecurity_codesigning
, libsecurity_utilities, perl, libsecurity_apple_csp
, xcbuild, Security}:
appleDerivation {
  buildInputs = [
    libsecurity_utilities
    libsecurity_cdsa_utilities
    libsecurity_cdsa_client
    perl
    libsecurity_cdsa_plugin
    xcbuild
    libsecurity_codesigning
  ];
  NIX_CFLAGS_COMPILE = "-I.";
  preBuild = ''
    ln -s ${Security}/Library/Frameworks/Security.framework/Headers Security
  '';
  patchPhase = ''
    substituteInPlace lib/cssmconfig.h \
      --replace CoreServices/../Frameworks/CarbonCore.framework/Headers/ConditionalMacros.h ConditionalMacros.h
  '';
  installPhase = ''
    mkdir -p $out/Library/Frameworks
    cp -r Products/security_cssm.framework $out/Library/Frameworks
    mkdir -p $out/Library/Frameworks/security_cssm.framework/Versions/Current
    cp Products/security_cssm $out/Library/Frameworks/security_cssm.framework/Versions/Current
    cp Products/security_cssm_debug_debug $out/Library/Frameworks/security_cssm.framework/Versions/Current/security_cssm_debug
    mkdir -p $out/include/Security
    cp lib/*.h $out/include/Security
  '';
}
