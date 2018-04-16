{ appleDerivation, libsecurity_cdsa_utilities, libsecurity_cssm, libsecurity_utilities, perl }:
appleDerivation {
  buildInputs = [
    libsecurity_cdsa_utilities
    libsecurity_utilities
    perl
  ];
  patchPhase = ''
    unpackFile ${libsecurity_cssm.src}
    cp libsecurity_cssm*/lib/cssm{dli,aci,cli,cspi,tpi}.h lib
    # cp libsecurity_cssm*/lib/*.h lib
    substituteInPlace lib/cssmconfig.h --replace \
      '<CoreServices/../Frameworks/CarbonCore.framework/Headers/ConditionalMacros.h>' \
      '"ConditionalMacros.h"'
  '';
  preBuild = ''
    perl lib/generator.pl lib lib/generator.cfg lib lib || exit 1
  '';
}
