{ appleDerivation', stdenv }:

appleDerivation' stdenv {
  dontBuild = true;
  installPhase = ''
    runHook preInstall

    mkdir -p $out/Library/Frameworks/EAP8021X.framework/Headers

    cp EAP8021X.fproj/EAPClientProperties.h $out/Library/Frameworks/EAP8021X.framework/Headers

    runHook postInstall
  '';
}
