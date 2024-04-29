{ lib }:

rec {
  version = "1.70.0";

  srcHash = "sha256-+fpXHUqTltS+eHvX5qVSLqJkFZGXJ6fTmezDdkocXmY=";

  # submodule dependencies
  # these are fetched so we:
  #   1. don't fetch the many submodules we don't need
  #   2. avoid fetchSubmodules since it's prone to impurities
  submodules = {
    "cli/src/semgrep/semgrep_interfaces" = {
      owner = "semgrep";
      repo = "semgrep-interfaces";
      rev = "df63c8fe4695d742eb7c027cd5d12ccbb3395dab";
      hash = "sha256-UHF0rGKYCiefU42bk5T3oBW2GYT4HGSmRQYprfneOlY=";
    };
  };

  # fetch pre-built semgrep-core since the ocaml build is complex and relies on
  # the opam package manager at some point
  # pulling it out of the python wheel as r2c no longer release a built binary
  # on github releases
  core = {
    x86_64-linux = {
      platform = "any";
      hash = "sha256-DjIv5LTOZbjIr8BFqnIpH5h09KtxrggtA3xdCZ+OvZ8=";
    };
    aarch64-linux = {
      platform = "musllinux_1_0_aarch64.manylinux2014_aarch64";
      hash = "sha256-09zeVoSb61WeKHJZOLIHXHP+m6X5k7x38iU8jlpubBk=";
    };
    x86_64-darwin = {
      platform = "macosx_10_14_x86_64";
      hash = "sha256-nRpkJEeO8/cQmScg8vNuRLFfKcJZ7vG7pP37FqgcNlQ=";
    };
    aarch64-darwin = {
      platform = "macosx_11_0_arm64";
      hash = "sha256-SzqFYyWJFNyW5H5xEcxF1GsuLK9GoaqiAx94X754QpI=";
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
