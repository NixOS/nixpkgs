{ appleDerivation, xcbuild, IOKit }:

appleDerivation {
  buildInputs = [ xcbuild IOKit ];
  xcbuildFlags = "-target caffeinate";
  installPhase = ''
    install -D Products/Deployment/caffeinate $out/bin/caffeinate
  '';
}
