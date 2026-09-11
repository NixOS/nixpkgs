{
  home-assistant-custom-components,
  stdenv,
}:

stdenv.mkDerivation {
  inherit (home-assistant-custom-components.valetudo)
    pname
    version
    src
    meta
    ;

  installPhase = ''
    runHook preInstall

    mkdir $out
    cp custom_components/valetudo/res/icons.js $out/valetudo-icons.js

    runHook postInstall
  '';

  passthru.entrypoint = "valetudo-icons.js";
}
