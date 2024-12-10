{
  lib,
  fetchurl,
  lilypond,
}:

lilypond.overrideAttrs (oldAttrs: rec {
  version = "2.25.20";
  src = fetchurl {
    url = "https://lilypond.org/download/sources/v${lib.versions.majorMinor version}/lilypond-${version}.tar.gz";
    hash = "sha256-q+eVzm68m4FuAvWKB/Zys7stmT9arAQ/+J/q2AvLnbM=";
  };

  passthru.updateScript = {
    command = [
      ./update.sh
      "unstable"
    ];
    supportedFeatures = [ "commit" ];
  };
})
