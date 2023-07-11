{ appleDerivation', stdenvNoCC }:

appleDerivation' stdenvNoCC {
  dontBuild = true;
  installPhase = ''
    mkdir -p $out/include
    cp mDNSShared/dns_sd.h $out/include
  '';
}
