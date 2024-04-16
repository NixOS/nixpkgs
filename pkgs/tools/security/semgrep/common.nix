{ lib }:

rec {
  version = "1.67.0";

  srcHash = "sha256-B+2DgwU+yhU337yZh518Z2Tq0Wbun8WEXX9IpC0Ut/c=";

  # submodule dependencies
  # these are fetched so we:
  #   1. don't fetch the many submodules we don't need
  #   2. avoid fetchSubmodules since it's prone to impurities
  submodules = {
    "cli/src/semgrep/semgrep_interfaces" = {
      owner = "semgrep";
      repo = "semgrep-interfaces";
      rev = "3ee41bc436308a7c12b66247cfcb60df0aeff8ea";
      hash = "sha256-rlhArVSNJr4AgZw/TOOMPgpBOfHWsAm77YgrRdCjIzI=";
    };
  };

  # fetch pre-built semgrep-core since the ocaml build is complex and relies on
  # the opam package manager at some point
  # pulling it out of the python wheel as r2c no longer release a built binary
  # on github releases
  core = {
    x86_64-linux = {
      platform = "any";
      hash = "sha256-iv02L/dvcfI/9XubC+EOeqMaVwdXh0sqLv02j1fn1aM=";
    };
    aarch64-linux = {
      platform = "musllinux_1_0_aarch64.manylinux2014_aarch64";
      hash = "sha256-wFuEcgCuciAOR8MNCxHW8TCoji97g7dXUf06M0T9MWg=";
    };
    x86_64-darwin = {
      platform = "macosx_10_14_x86_64";
      hash = "sha256-wMkOZFvR6HBBTvu8mXRDF2s0Mqp/LkhVH2I+2sIIa94=";
    };
    aarch64-darwin = {
      platform = "macosx_11_0_arm64";
      hash = "sha256-AKNc9SxXbKb6WdFlE6aqzFDdtMGzl+3LhXTbNvFSHYQ=";
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
