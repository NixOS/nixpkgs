{ lib }:

rec {
  version = "1.172.0";

  srcHash = "sha256-dILO0ia4zriHiC1jVv02YOyj0Snni4aY66g+omApqSQ=";

  # This tag is used to select the correct wheel from PyPI.
  # It is updated by the update.sh script.
  pythonWheelTag = "cp310.cp311.cp312.cp313.cp314.py310.py311.py312.py313.py314";

  # submodule dependencies
  # these are fetched so we:
  #   1. don't fetch the many submodules we don't need
  #   2. avoid fetchSubmodules since it's prone to impurities
  submodules = {
    "cli/src/semgrep/semgrep_interfaces" = {
      owner = "semgrep";
      repo = "semgrep-interfaces";
      rev = "6dc898658d554ce80e6fdd58904adea2fd0e30c8";
      hash = "sha256-7JMo2TU5JbPscrfI1qdz1P2bF6J8dTDhOqAQXxa3tm8=";
    };
  };

  # fetch pre-built semgrep-core since the ocaml build is complex and relies on
  # the opam package manager at some point
  # pulling it out of the python wheel as r2c no longer release a built binary
  # on github releases
  core = {
    x86_64-linux = {
      platform = "manylinux_2_34_x86_64";
      hash = "sha256-2LlK9CZqV1KHrSzYRFc3Q6tP5Y9r+22SKTJ4B5N+reM=";
    };
    aarch64-linux = {
      platform = "manylinux_2_34_aarch64";
      hash = "sha256-yIGjBbll5ZS4ixXCxkGbOY525DjsYeYJFsiy7/6SckA=";
    };
    aarch64-darwin = {
      platform = "macosx_11_0_arm64";
      hash = "sha256-CeksnmwWNaFUnU4pey1KloTc01GyFu1/LrUc/FVHnEk=";
    };
  };

  meta = {
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
    license = lib.licenses.lgpl21Plus;
    maintainers = with lib.maintainers; [
      jk
      ambroisie
      caverav
    ];
  };
}
