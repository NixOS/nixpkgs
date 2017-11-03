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
  '';
  preBuild = ''
    perl lib/generator.pl lib lib/generator.cfg lib lib || exit 1
  '';
}
