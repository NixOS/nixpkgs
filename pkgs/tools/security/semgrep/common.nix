{ lib }:

rec {
  version = "1.34.1";

  srcHash = "sha256-jbwG3Xyb/rEyz7aR51/pfc+bU/KY9k6BsByZg6KDY5s=";

  # submodule dependencies
  # these are fetched so we:
  #   1. don't fetch the many submodules we don't need
  #   2. avoid fetchSubmodules since it's prone to impurities
  submodules = {
    "cli/src/semgrep/semgrep_interfaces" = {
      owner = "returntocorp";
      repo = "semgrep-interfaces";
      rev = "f7fed064dadb859f0b802b11fb60f7f77008c4d7";
      hash = "sha256-EXYRc6p94QxkOBMPOdr608JqLY6kN1AanlRfOFXxPm8=";
    };
  };

  # fetch pre-built semgrep-core since the ocaml build is complex and relies on
  # the opam package manager at some point
  # pulling it out of the python wheel as r2c no longer release a built binary
  # on github releases
  core = {
    x86_64-linux = {
      platform = "any";
      hash = "sha256-XogITZZtuNmWBrCfL5qpHJNm6jFxzraZMXWhUotXA4c=";
    };
    x86_64-darwin = {
      platform = "macosx_10_14_x86_64";
      hash = "sha256-YjV915SZ2L8t6huToErTHRd82m4I+evPyeuwpVzi26o=";
    };
    aarch64-darwin = {
      platform = "macosx_11_0_arm64";
      hash = "sha256-BAnYYeUWosAorcHpqUMpRXJFl4NQDPbWTsykDN3w5UQ=";
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
