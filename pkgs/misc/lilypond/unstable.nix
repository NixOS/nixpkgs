{ lib, fetchurl, lilypond }:

lilypond.overrideAttrs (oldAttrs: rec {
  version = "2.25.3";
  src = fetchurl {
    url = "https://lilypond.org/download/sources/v${lib.versions.majorMinor version}/lilypond-${version}.tar.gz";
    sha256 = "sha256-CVMMzL31NWd6PKf66m0ctBXFpqHMwxQibuifaU9lftg=";
  };

  passthru.updateScript = {
    command = [ ./update.sh "unstable" ];
    supportedFeatures = [ "commit" ];
  };
})
