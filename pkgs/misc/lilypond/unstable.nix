{
  lib,
  fetchurl,
  lilypond,
}:

lilypond.overrideAttrs (oldAttrs: rec {
  version = "2.25.24";
  src = fetchurl {
    url = "https://lilypond.org/download/sources/v${lib.versions.majorMinor version}/lilypond-${version}.tar.gz";
    hash = "sha256-1n6mJBbZcfQYsmrjWxcG/EtIyF9uHNRVT7fX3+zoXc4=";
  };

  passthru.updateScript = {
    command = [
      ./update.sh
      "unstable"
    ];
    supportedFeatures = [ "commit" ];
  };
})
