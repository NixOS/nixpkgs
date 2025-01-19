{ lib }:

rec {
  version = "1.96.0";

  srcHash = "sha256-5acpMDSUqQvQuUWho7Uk5RwU0FopaIzvCQ3/SmmE36Q=";

  # submodule dependencies
  # these are fetched so we:
  #   1. don't fetch the many submodules we don't need
  #   2. avoid fetchSubmodules since it's prone to impurities
  submodules = {
    "cli/src/semgrep/semgrep_interfaces" = {
      owner = "semgrep";
      repo = "semgrep-interfaces";
      rev = "14462086a61d29cafd5e0b19c3ccd950dad9643f";
      hash = "sha256-ASBpKPlb9NrttYnmd+b8hifgel/QDZAx2TfIZLRdzSg=";
    };
  };

  # fetch pre-built semgrep-core since the ocaml build is complex and relies on
  # the opam package manager at some point
  # pulling it out of the python wheel as r2c no longer release a built binary
  # on github releases
  core = {
    x86_64-linux = {
      platform = "any";
      hash = "sha256-tVxw9KjBqqgEDk7LLTbzWPjBMg2mRwtbVe94EQkBYEo=";
    };
    aarch64-linux = {
      platform = "musllinux_1_0_aarch64.manylinux2014_aarch64";
      hash = "sha256-c11y057rAyAs4U18GOHSNSbb8mXkfDsR7Dz+fHRQg7w=";
    };
    x86_64-darwin = {
      platform = "macosx_10_14_x86_64";
      hash = "sha256-JVKYxHHNX9oY92L62vz788m4IzOv6nBoN6FO6p5nnJ0=";
    };
    aarch64-darwin = {
      platform = "macosx_11_0_arm64";
      hash = "sha256-F3xDN18Zh2y9wVlzTe+khA9Tf31lPDDzte/OsqTloGc=";
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
