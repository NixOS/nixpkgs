{ lib }:

rec {
  version = "1.69.0";

  srcHash = "sha256-LA0mRuYJg97tMbmlmJpZ8wQc83S/jXNWBUjcoXSqoVo=";

  # submodule dependencies
  # these are fetched so we:
  #   1. don't fetch the many submodules we don't need
  #   2. avoid fetchSubmodules since it's prone to impurities
  submodules = {
    "cli/src/semgrep/semgrep_interfaces" = {
      owner = "semgrep";
      repo = "semgrep-interfaces";
      rev = "d5b91fa4f6a03240db31e9bbbc5376a99bc8eeea";
      hash = "sha256-IQ22HvO0gHAfbZrt+bz1yMb/XRZOU+z03X+SOK9iDQs=";
    };
  };

  # fetch pre-built semgrep-core since the ocaml build is complex and relies on
  # the opam package manager at some point
  # pulling it out of the python wheel as r2c no longer release a built binary
  # on github releases
  core = {
    x86_64-linux = {
      platform = "any";
      hash = "sha256-QFE8NzGW2kkP5xtmbXgxE1OAxz6z7MT8wW/EmIVMgHE=";
    };
    aarch64-linux = {
      platform = "musllinux_1_0_aarch64.manylinux2014_aarch64";
      hash = "sha256-E1fGT5TO2DbP4oYtkRs794jXGOp75q3o+xlOao8E7Lk=";
    };
    x86_64-darwin = {
      platform = "macosx_10_14_x86_64";
      hash = "sha256-oWY57rQvxjMIhzjR62cpIVmKynmdF3zQOLMHBjbf1ig=";
    };
    aarch64-darwin = {
      platform = "macosx_11_0_arm64";
      hash = "sha256-L2eFkahzwfBzPcx7Zq+NhtgJvBq5W1vZ4m1YNQ3dWAo=";
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
