{ lib }:

rec {
  version = "1.74.0";

  srcHash = "sha256-PH0fTT6n6o3Jtuq+cyyRb048Tuv3VGNduCZCEKTXMrE=";

  # submodule dependencies
  # these are fetched so we:
  #   1. don't fetch the many submodules we don't need
  #   2. avoid fetchSubmodules since it's prone to impurities
  submodules = {
    "cli/src/semgrep/semgrep_interfaces" = {
      owner = "semgrep";
      repo = "semgrep-interfaces";
      rev = "9f38254957c50c68ea402eebae0f7aa40dd01cbf";
      hash = "sha256-/P8b7nSwNZSrm7dUFkehDaGz+r+bofrlFfuIo4U7tJM=";
    };
  };

  # fetch pre-built semgrep-core since the ocaml build is complex and relies on
  # the opam package manager at some point
  # pulling it out of the python wheel as r2c no longer release a built binary
  # on github releases
  core = {
    x86_64-linux = {
      platform = "any";
      hash = "sha256-ZA5KlbSLkC0IJGqyK0XhuDKRx53987vf53vSM0zwD9k=";
    };
    aarch64-linux = {
      platform = "musllinux_1_0_aarch64.manylinux2014_aarch64";
      hash = "sha256-aHq87uzk9TtnlMDfAS6492ocXRJSHdBinng0hu2xLas=";
    };
    x86_64-darwin = {
      platform = "macosx_10_14_x86_64";
      hash = "sha256-OorDXQ0oYHV8aPu9o1dQAd22u78/EjpUWA2yPYG0S9E=";
    };
    aarch64-darwin = {
      platform = "macosx_11_0_arm64";
      hash = "sha256-g8sFLh2V9NDIvAZOaDhMpFxKqbS/S1eKep4v1vlOOo8=";
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
