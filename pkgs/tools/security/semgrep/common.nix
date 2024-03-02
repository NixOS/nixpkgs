{ lib }:

rec {
  version = "1.62.0";

  srcHash = "sha256-P6plFE/tUVR6KvTZ+6RYr+Wq9W8hI7wmVnap4NMQAZU=";

  # submodule dependencies
  # these are fetched so we:
  #   1. don't fetch the many submodules we don't need
  #   2. avoid fetchSubmodules since it's prone to impurities
  submodules = {
    "cli/src/semgrep/semgrep_interfaces" = {
      owner = "semgrep";
      repo = "semgrep-interfaces";
      rev = "bbfd1c5b91bd411bceffc3de73f5f0b37f04433d";
      hash = "sha256-wrhV5bBuIpVYehzVTxussiED//ObJXQSfPiiKnIR/DM=";
    };
  };

  # fetch pre-built semgrep-core since the ocaml build is complex and relies on
  # the opam package manager at some point
  # pulling it out of the python wheel as r2c no longer release a built binary
  # on github releases
  core = {
    x86_64-linux = {
      platform = "any";
      hash = "sha256-GQAKw3Q2RFuCnVFeT5OE2ybBBAMYtLx3GZyqFHDF89A=";
    };
    x86_64-darwin = {
      platform = "macosx_10_14_x86_64";
      hash = "sha256-gFes5goprwIrA5PYMwtzgtn2Q+CcFHogvLr9XaAZ2m4=";
    };
    aarch64-darwin = {
      platform = "macosx_11_0_arm64";
      hash = "sha256-ozDT2RGExMgVs2vaTGI3IrtzGD17W5ZcIGaEgyv+GZw=";
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
