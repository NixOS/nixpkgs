{ lib }:

rec {
  version = "1.61.1";

  srcHash = "sha256-muTw6rj9FuSSXvUzdP4QRQogzmUPlrvGARRK/Jqg+Gc=";

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
      hash = "sha256-lX/zRgkEyoln69pf4fWtb8f9wffBOI/KkCegn8kFmj4=";
    };
    x86_64-darwin = {
      platform = "macosx_10_14_x86_64";
      hash = "sha256-Rk4qP/iKpRUbqdry6V/NmXRQLkA0e9ltIOdYiO5DuTg=";
    };
    aarch64-darwin = {
      platform = "macosx_11_0_arm64";
      hash = "sha256-Gqq9LGwZ96i8LU8Z8qSN3TxuUUTDYrJiVCY9rm7aNzI=";
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
