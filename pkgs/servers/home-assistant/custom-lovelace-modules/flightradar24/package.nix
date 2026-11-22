{
  home-assistant-custom-components,
  stdenv,
}:

stdenv.mkDerivation {
  inherit (home-assistant-custom-components.flightradar24)
    pname
    version
    src
    meta
    ;

  installPhase = ''
    runHook preInstall

    mkdir $out
    cp custom_components/flightradar24/frontend/flightradar24-card.js $out/

    runHook postInstall
  '';

  passthru.entrypoint = "flightradar24-card.js";
}
