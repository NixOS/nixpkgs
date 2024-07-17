{
  lib,
  fetchurl,
  lilypond,
}:

lilypond.overrideAttrs (oldAttrs: rec {
  version = "2.25.17";
  src = fetchurl {
    url = "https://lilypond.org/download/sources/v${lib.versions.majorMinor version}/lilypond-${version}.tar.gz";
    hash = "sha256-AVGd/H2+lQxUYyXGB2dOBU4rpqR5LSkn3ishu5uqDYs=";
  };

  passthru.updateScript = {
    command = [
      ./update.sh
      "unstable"
    ];
    supportedFeatures = [ "commit" ];
  };
})
