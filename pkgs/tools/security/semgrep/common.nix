{ lib }:

rec {
  version = "1.35.0";

  srcHash = "sha256-SUKswvY49Hxis5CwguXC5QSshG0sGKb23mz2IT1vNJI=";

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
      hash = "sha256-ZqSbiuVKGjH+2fB0ReSw07CzTDSK35a8Adstzrvh8zA=";
    };
    x86_64-darwin = {
      platform = "macosx_10_14_x86_64";
      hash = "sha256-MusoteFarPJm8eQO7T/LrXDWUV0Wx4nw80ZvjG7HHhM=";
    };
    aarch64-darwin = {
      platform = "macosx_11_0_arm64";
      hash = "sha256-xN87fp5jqes/smMrtLbZowMIuTevpDJNFNeWdo0Seu4=";
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
