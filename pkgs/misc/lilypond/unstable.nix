{ lib, fetchurl, lilypond }:

lilypond.overrideAttrs (oldAttrs: rec {
<<<<<<< HEAD
  version = "2.25.7";
  src = fetchurl {
    url = "https://lilypond.org/download/sources/v${lib.versions.majorMinor version}/lilypond-${version}.tar.gz";
    sha256 = "sha256-b7prbe4lnUfiLGcmWbrjXTTXqJTX4PsAMBbSvZgHLwI=";
=======
  version = "2.25.4";
  src = fetchurl {
    url = "https://lilypond.org/download/sources/v${lib.versions.majorMinor version}/lilypond-${version}.tar.gz";
    sha256 = "sha256-O7YQc00774Nz6KIGC1Za1HBvKaHmUjXeKkZs0YR1HUA=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  passthru.updateScript = {
    command = [ ./update.sh "unstable" ];
    supportedFeatures = [ "commit" ];
  };
})
