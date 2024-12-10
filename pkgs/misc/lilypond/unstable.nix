{ lib, fetchurl, lilypond }:

lilypond.overrideAttrs (oldAttrs: rec {
  version = "2.25.21";
  src = fetchurl {
    url = "https://lilypond.org/download/sources/v${lib.versions.majorMinor version}/lilypond-${version}.tar.gz";
    hash = "sha256-mckXCpZLig0ePkeGpiqYQQREFxgioiK/+mpA3GBNwGc=";
  };

  passthru.updateScript = {
    command = [ ./update.sh "unstable" ];
    supportedFeatures = [ "commit" ];
  };
})
