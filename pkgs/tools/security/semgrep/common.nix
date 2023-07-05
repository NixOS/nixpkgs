{ lib }:

rec {
  version = "1.27.0";

  srcHash = "sha256-F6n3LQY4a5sO6c8SMQF9YjjgOS+v2SH+UQPwhg2EX7Q=";

  # submodule dependencies
  # these are fetched so we:
  #   1. don't fetch the many submodules we don't need
  #   2. avoid fetchSubmodules since it's prone to impurities
  submodules = {
    "cli/src/semgrep/semgrep_interfaces" = {
      owner = "returntocorp";
      repo = "semgrep-interfaces";
      rev = "213f67abea73546ca6111e1bbf0ef96aa917c940";
      hash = "sha256-HeNHJkTje9j16+dwsfyMhoqQn/J18q/7XvQPRwgTw/Y=";
    };
  };

  # fetch pre-built semgrep-core since the ocaml build is complex and relies on
  # the opam package manager at some point
  # pulling it out of the python wheel as r2c no longer release a built binary
  # on github releases
  core = {
    x86_64-linux = {
      platform = "any";
      hash = "sha256-cRj81dXpAE6S0EXajsRikOIAPzlUf42FhiDCWjv+wZQ=";
    };
    x86_64-darwin = {
      platform = "macosx_10_14_x86_64";
      hash = "sha256-jqfGVZGF/DFgXkr7kQg6QyqEELSr8AKE3Ga8kTftnIY=";
    };
    aarch64-darwin = {
      platform = "macosx_11_0_arm64";
      hash = "sha256-e/uCSRMdbVD0lvc0hukbiUzheqRNIIh1LgMq6Ae7JYI=";
    };
  };

  meta = with lib; {
    homepage = "https://semgrep.dev/";
    downloadPage = "https://github.com/returntocorp/semgrep/";
    changelog = "https://github.com/returntocorp/semgrep/blob/v${version}/CHANGELOG.md";
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
