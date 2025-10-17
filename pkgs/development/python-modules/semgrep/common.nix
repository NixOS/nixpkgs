{ lib }:

rec {
  version = "1.140.0";

  srcHash = "sha256-RLcES0kamYMlLo1L4Y+mSJDB91SP84h75oLQxX9eCjQ=";

  # submodule dependencies
  # these are fetched so we:
  #   1. don't fetch the many submodules we don't need
  #   2. avoid fetchSubmodules since it's prone to impurities
  submodules = {
    "cli/src/semgrep/semgrep_interfaces" = {
      owner = "semgrep";
      repo = "semgrep-interfaces";
      rev = "8baadf6b8604b59c9a660dbb371726c12a3666b8";
      hash = "sha256-37sEprdR8I45tRYsXNNFz0okoTH32MJU9EvMogEMtMw=";
    };
  };

  # fetch pre-built semgrep-core since the ocaml build is complex and relies on
  # the opam package manager at some point
  # pulling it out of the python wheel as r2c no longer release a built binary
  # on github releases
  core = {
    x86_64-linux = {
      platform = "musllinux_1_0_x86_64.manylinux2014_x86_64";
      hash = "sha256-/aZnv5a7ifSk1l98Qf+HKQhnrHKi88SKTuJZwQ7Ons4=";
    };
    aarch64-linux = {
      platform = "musllinux_1_0_aarch64.manylinux2014_aarch64";
      hash = "sha256-f0k/sNME/0JGrvV7/H47jWLY3OadslzljfA7Kpp0STo=";
    };
    x86_64-darwin = {
      platform = "macosx_10_14_x86_64";
      hash = "sha256-HldS8Rcx+OkFYfBr/5+rMXVg8prrAuBCDTbkgb8DVsQ=";
    };
    aarch64-darwin = {
      platform = "macosx_11_0_arm64";
      hash = "sha256-LiIO4Smomx6tHTtg8ewwXaKXdJDpcmE+auJ5FjWi990=";
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
    maintainers = with maintainers; [
      jk
      ambroisie
    ];
  };
}
