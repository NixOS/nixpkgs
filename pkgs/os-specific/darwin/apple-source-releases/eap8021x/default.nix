{ stdenv, appleDerivation }:

appleDerivation {
  phases = [ "unpackPhase" "installPhase" "fixupPhase" ];

  installPhase = ''
    mkdir -p $out/Library/Frameworks/EAP8021X.framework/Headers

    cp EAP8021X.fproj/EAPClientProperties.h $out/Library/Frameworks/EAP8021X.framework/Headers
  '';
}