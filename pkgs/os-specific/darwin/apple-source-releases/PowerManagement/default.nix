{ appleDerivation, xcbuildHook, IOKit }:

appleDerivation {
  nativeBuildInputs = [ xcbuildHook ];
  buildInputs = [ IOKit ];
  xcbuildFlags = [ "-target" "caffeinate" ];
  installPhase = ''
    runHook preInstall

    install -D Products/Deployment/caffeinate $out/bin/caffeinate

    runHook postInstall
  '';
}
