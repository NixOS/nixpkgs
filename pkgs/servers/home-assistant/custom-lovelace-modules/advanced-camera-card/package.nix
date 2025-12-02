{
  lib,
  stdenv,
  fetchzip,
}:

stdenv.mkDerivation rec {
  pname = "advanced-camera-card";
  version = "7.19.4";

  src = fetchzip {
    url = "https://github.com/dermotduffy/advanced-camera-card/releases/download/v${version}/advanced-camera-card.zip";
    hash = "sha256-fxNCF0mmfTo08UQJUF5ZGYi5EPN/SVKZI9Uo0TMRzw8=";
  };

  # TODO: build from source once yarn berry support lands in nixpkgs
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    install -d $out
    install -m0644 *.js $out/

    runHook postInstall
  '';

  meta = {
    changelog = "https://github.com/dermotduffy/advanced-camera-card/releases/tag/v${version}";
    description = "Comprehensive camera card for Home Assistant";
    homepage = "https://github.com/dermotduffy/advanced-camera-card";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hexa ];
  };
}
