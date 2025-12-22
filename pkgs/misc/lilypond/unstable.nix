{
  lib,
  fetchzip,
  lilypond,
}:

lilypond.overrideAttrs (oldAttrs: rec {
  version = "2.25.31";
  src = fetchzip {
    url = "https://lilypond.org/download/sources/v${lib.versions.majorMinor version}/lilypond-${version}.tar.gz";
    hash = "sha256-GQ4ZpXQOsNWEM5juiijA7L4F9eGY2DsRNaAhH7TH5y0=";
  };

  passthru.updateScript = {
    command = [
      ./update.sh
      "unstable"
    ];
    supportedFeatures = [ "commit" ];
  };
})
