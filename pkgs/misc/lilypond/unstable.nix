{ lib, fetchurl, lilypond }:

lilypond.overrideAttrs (oldAttrs: rec {
  version = "2.25.18";
  src = fetchurl {
    url = "https://lilypond.org/download/sources/v${lib.versions.majorMinor version}/lilypond-${version}.tar.gz";
    hash = "sha256-dCkIb+fr6zs/5F3JT3Za4KKGWECwzJN3eHgy4Ea/M/Q=";
  };

  passthru.updateScript = {
    command = [ ./update.sh "unstable" ];
    supportedFeatures = [ "commit" ];
  };
})
