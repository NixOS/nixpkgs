{
  lib,
  fetchzip,
  lilypond,
}:

lilypond.overrideAttrs (oldAttrs: rec {
  version = "2.25.28";
  src = fetchzip {
    url = "https://lilypond.org/download/sources/v${lib.versions.majorMinor version}/lilypond-${version}.tar.gz";
    hash = "sha256-zqK1KG56OFt+W79pEKaarcUIQcFNdNUt4mObAEEjFJY=";
  };

  passthru.updateScript = {
    command = [
      ./update.sh
      "unstable"
    ];
    supportedFeatures = [ "commit" ];
  };
})
