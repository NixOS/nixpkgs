{
  lib,
  fetchzip,
  lilypond,
}:

lilypond.overrideAttrs (oldAttrs: rec {
  version = "2.25.32";
  src = fetchzip {
    url = "https://lilypond.org/download/sources/v${lib.versions.majorMinor version}/lilypond-${version}.tar.gz";
    hash = "sha256-j7Avb9WSy27yQCak3KV7OB24M+T76b/tLcLoINLSEbo=";
  };

  passthru.updateScript = {
    command = [
      ./update.sh
      "unstable"
    ];
    supportedFeatures = [ "commit" ];
  };
})
