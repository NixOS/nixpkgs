{
  lib,
  fetchzip,
  lilypond,
}:

lilypond.overrideAttrs (oldAttrs: rec {
  version = "2.25.27";
  src = fetchzip {
    url = "https://lilypond.org/download/sources/v${lib.versions.majorMinor version}/lilypond-${version}.tar.gz";
    hash = "sha256-cZ6XZt1y646Kke3wdJ5Jo9ieOejbojsEBSkAvLDXNPw=";
  };

  passthru.updateScript = {
    command = [
      ./update.sh
      "unstable"
    ];
    supportedFeatures = [ "commit" ];
  };
})
