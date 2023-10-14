{ lib, fetchurl, lilypond }:

lilypond.overrideAttrs (oldAttrs: rec {
  version = "2.25.8";
  src = fetchurl {
    url = "https://lilypond.org/download/sources/v${lib.versions.majorMinor version}/lilypond-${version}.tar.gz";
    hash = "sha256-pycbGmVp3HVKOAGpe4gEmBWjMT2BqrSqKISsAZCEkx0=";
  };

  passthru.updateScript = {
    command = [ ./update.sh "unstable" ];
    supportedFeatures = [ "commit" ];
  };
})
