{
  lib,
  fetchzip,
  lilypond,
}:

lilypond.overrideAttrs (oldAttrs: rec {
  version = "2.25.29";
  src = fetchzip {
    url = "https://lilypond.org/download/sources/v${lib.versions.majorMinor version}/lilypond-${version}.tar.gz";
    hash = "sha256-t6EnGCD0QMARK1/yJBjtLFzVaBWiiut8KWrtzmzHgCM=";
  };

  passthru.updateScript = {
    command = [
      ./update.sh
      "unstable"
    ];
    supportedFeatures = [ "commit" ];
  };
})
