{ lib }:

rec {
  version = "1.144.0";

  srcHash = "sha256-mfYomG1VkE06jz+kRpRye5kLqM22wPLbkPckH5xDUek=";

  # submodule dependencies
  # these are fetched so we:
  #   1. don't fetch the many submodules we don't need
  #   2. avoid fetchSubmodules since it's prone to impurities
  submodules = {
    "cli/src/semgrep/semgrep_interfaces" = {
      owner = "semgrep";
      repo = "semgrep-interfaces";
      rev = "e2ba73ae7838711a71cbbc89f978fbd221ae0dbd";
      hash = "sha256-Z1vHzyU7ZKWJ4ChUIZFvEyqwOBtguZCWyAugqDWFZPU=";
    };
  };

  # fetch pre-built semgrep-core since the ocaml build is complex and relies on
  # the opam package manager at some point
  # pulling it out of the python wheel as r2c no longer release a built binary
  # on github releases
  core = {
    x86_64-linux = {
      platform = "musllinux_1_0_x86_64.manylinux2014_x86_64";
      hash = "sha256-cK4KVxumyNDkDDRFMeRbgcZBcPVo2nlPCnLKTeklqcw=";
    };
    aarch64-linux = {
      platform = "musllinux_1_0_aarch64.manylinux2014_aarch64";
      hash = "sha256-HoiJzbvSszaTDFz3nBsfeOgnNLHShj3rjSDoTl4ksuI=";
    };
    x86_64-darwin = {
      platform = "macosx_10_14_x86_64";
      hash = "sha256-fK14/4o7c9EprKVaXGYWENzmluiW/oF898V8SeI+gPo=";
    };
    aarch64-darwin = {
      platform = "macosx_11_0_arm64";
      hash = "sha256-oQtQdtUM31677HIFgGedaaEXJIXVL5+/JLEa9eNnbQ8=";
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
