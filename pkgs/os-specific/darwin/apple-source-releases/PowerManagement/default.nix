{
  appleDerivation,
  xcbuildHook,
  IOKit,
}:

appleDerivation {
  nativeBuildInputs = [ xcbuildHook ];
  buildInputs = [ IOKit ];
  xcbuildFlags = [
    "-target"
    "caffeinate"
  ];
  installPhase = ''
    install -D Products/Deployment/caffeinate $out/bin/caffeinate
  '';
}
