{
  lib,
  stdenv,
  fetchzip,
}:

stdenv.mkDerivation rec {
  pname = "advanced-camera-card";
  version = "7.3.3";

  src = fetchzip {
    url = "https://github.com/dermotduffy/advanced-camera-card/releases/download/v${version}/advanced-camera-card.zip";
    hash = "sha256-4qsOSfO8a2Wq+kO2l2CbjsEOM+pd4/ofcu41smnlV3E=";
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
    description = "A comprehensive camera card for Home Assistant";
    homepage = "https://github.com/dermotduffy/advanced-camera-card";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hexa ];
  };
}
