{ lib }:

rec {
  version = "1.71.0";

  srcHash = "sha256-KLDyKNo2oAQlcT9J2SbPSGJvUkxbT05IdEjl5YPBZqA=";

  # submodule dependencies
  # these are fetched so we:
  #   1. don't fetch the many submodules we don't need
  #   2. avoid fetchSubmodules since it's prone to impurities
  submodules = {
    "cli/src/semgrep/semgrep_interfaces" = {
      owner = "semgrep";
      repo = "semgrep-interfaces";
      rev = "75abf193687b84ab341d8267d865ad68d81a89c9";
      hash = "sha256-pS95f9oZLtzCEOQrjJP6aGm6lrltumG4ZjSTaUcRDpU=";
    };
  };

  # fetch pre-built semgrep-core since the ocaml build is complex and relies on
  # the opam package manager at some point
  # pulling it out of the python wheel as r2c no longer release a built binary
  # on github releases
  core = {
    x86_64-linux = {
      platform = "any";
      hash = "sha256-0pEpxIYed0Z086l1apJXuEVW1Hly4HauzHD8bjxR1Zw=";
    };
    aarch64-linux = {
      platform = "musllinux_1_0_aarch64.manylinux2014_aarch64";
      hash = "sha256-6VefgA4YFiY7fsy7sbQFXCjsJNM4+vlv6uLSrzBd2qI=";
    };
    x86_64-darwin = {
      platform = "macosx_10_14_x86_64";
      hash = "sha256-wgCaS7Lw1FP42mOZmhO5v2Nz8PnDEkEP2gbxr7aGtDk=";
    };
    aarch64-darwin = {
      platform = "macosx_11_0_arm64";
      hash = "sha256-IZc2RZbAYpflkszl5lFutxikwtO6XGoyyeHJIhU/K+k=";
    };
  };

  meta = with lib; {
    homepage = "https://semgrep.dev/";
    downloadPage = "https://github.com/semgrep/semgrep/";
    changelog = "https://github.com/semgrep/semgrep/blob/v${version}/CHANGELOG.md";
    description = "Lightweight static analysis for many languages";
    longDescription = ''
      Semgrep is a fast, open-source, static analysis tool for finding bugs and
      enforcing code standards at editor, commit, and CI time. Semgrep analyzes
      code locally on your computer or in your build environment: code is never
      uploaded. Its rules look like the code you already write; no abstract
      syntax trees, regex wrestling, or painful DSLs.
    '';
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ jk ambroisie ];
  };
}
