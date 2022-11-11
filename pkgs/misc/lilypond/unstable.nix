{ lib, fetchurl, guile, lilypond }:

(lilypond.override {
  inherit guile;
}).overrideAttrs (oldAttrs: rec {
  version = "2.23.12";
  src = fetchurl {
    url = "https://lilypond.org/download/sources/v${lib.versions.majorMinor version}/lilypond-${version}.tar.gz";
    sha256 = "sha256-SLZ9/Jybltd8+1HANk8pTGHRb7MuZSJJDDY/S4Kwz/k=";
  };
})
