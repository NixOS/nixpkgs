{ lib, fetchurl, lilypond }:

lilypond.overrideAttrs (oldAttrs: rec {
  version = "2.25.4";
  src = fetchurl {
    url = "https://lilypond.org/download/sources/v${lib.versions.majorMinor version}/lilypond-${version}.tar.gz";
    sha256 = "sha256-O7YQc00774Nz6KIGC1Za1HBvKaHmUjXeKkZs0YR1HUA=";
  };

  passthru.updateScript = {
    command = [ ./update.sh "unstable" ];
    supportedFeatures = [ "commit" ];
  };
})
