{ lib, fetchurl, guile, lilypond }:

(lilypond.override {
  inherit guile;
}).overrideAttrs (oldAttrs: rec {
  version = "2.23.11";
  src = fetchurl {
    url = "https://lilypond.org/download/sources/v${lib.versions.majorMinor version}/lilypond-${version}.tar.gz";
    sha256 = "sha256-4VjcuZvRmpPmiZ42zyk9xYPlsSN6kEsBSRe30P+raQ8=";
  };
})
