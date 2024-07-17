{
  lib,
  fetchurl,
  lilypond,
}:

lilypond.overrideAttrs (oldAttrs: rec {
  version = "2.25.15";
  src = fetchurl {
    url = "https://lilypond.org/download/sources/v${lib.versions.majorMinor version}/lilypond-${version}.tar.gz";
    hash = "sha256-K2CV4sWhUndiglBze44xbfrPe19nU+9qn+WOWLMA0R8=";
  };

  passthru.updateScript = {
    command = [
      ./update.sh
      "unstable"
    ];
    supportedFeatures = [ "commit" ];
  };
})
