{ appleDerivation', stdenvNoCC }:

appleDerivation' stdenvNoCC {
  dontBuild = true;
  installPhase = ''
    mkdir -p $out/include
    # TODO: Do this only for 765.50.9 once there is a way to apply version-specific
    # logic in a source-release derivation.
    substitute mDNSShared/dns_sd.h $out/include/dns_sd.h \
      --replace '#define _DNS_SD_LIBDISPATCH 0' '#define _DNS_SD_LIBDISPATCH 1'
  '';
}
