{
  lib,
  stdenv,
  fetchzip,
}:

stdenv.mkDerivation rec {
  pname = "advanced-camera-card";
<<<<<<< HEAD
  version = "7.26.0";

  src = fetchzip {
    url = "https://github.com/dermotduffy/advanced-camera-card/releases/download/v${version}/advanced-camera-card.zip";
    hash = "sha256-2f+peUfhvreJPZfZt9dOvf0pItWCgzcNfH0iRLsRwGE=";
=======
  version = "7.19.3";

  src = fetchzip {
    url = "https://github.com/dermotduffy/advanced-camera-card/releases/download/v${version}/advanced-camera-card.zip";
    hash = "sha256-Y6wwpemByMIEh1HSllD/fuNrXPLFd5kpcjsETlfZcks=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
