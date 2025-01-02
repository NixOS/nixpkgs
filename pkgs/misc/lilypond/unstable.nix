{
  lib,
  fetchurl,
  lilypond,
}:

lilypond.overrideAttrs (oldAttrs: rec {
  version = "2.25.22";
  src = fetchurl {
    url = "https://lilypond.org/download/sources/v${lib.versions.majorMinor version}/lilypond-${version}.tar.gz";
    hash = "sha256-+p0D//hU/AKVJ6DuPhoK9EOqZxZpTVRugabxidmHYLU=";
  };

  passthru.updateScript = {
    command = [
      ./update.sh
      "unstable"
    ];
    supportedFeatures = [ "commit" ];
  };
})
