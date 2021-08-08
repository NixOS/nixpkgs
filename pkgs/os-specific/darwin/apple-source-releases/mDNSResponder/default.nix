{ appleDerivation', stdenvNoCC }:

appleDerivation' stdenvNoCC {
  phases = [ "unpackPhase" "installPhase" ];

  installPhase = ''
    mkdir -p $out/include
    cp mDNSShared/dns_sd.h $out/include
  '';
}
