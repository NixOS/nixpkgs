{ lib }:

rec {
  version = "1.72.0";

  srcHash = "sha256-Rfu4ymNQ9AXuj5nkx01eUtIVMXDmunNTvUH/2Y7VaXM=";

  # submodule dependencies
  # these are fetched so we:
  #   1. don't fetch the many submodules we don't need
  #   2. avoid fetchSubmodules since it's prone to impurities
  submodules = {
    "cli/src/semgrep/semgrep_interfaces" = {
      owner = "semgrep";
      repo = "semgrep-interfaces";
      rev = "75abf193687b84ab341d8267d865ad68d81a89c9";
      hash = "sha256-pS95f9oZLtzCEOQrjJP6aGm6lrltumG4ZjSTaUcRDpU=";
    };
  };

  # fetch pre-built semgrep-core since the ocaml build is complex and relies on
  # the opam package manager at some point
  # pulling it out of the python wheel as r2c no longer release a built binary
  # on github releases
  core = {
    x86_64-linux = {
      platform = "any";
      hash = "sha256-/XZzzDbsW6pw8LC8DgofZ1Gr7eeQyH719NzJDCoXhpk=";
    };
    aarch64-linux = {
      platform = "musllinux_1_0_aarch64.manylinux2014_aarch64";
      hash = "sha256-7zCy2IbxsNO1Jl/efu9dwSyvv6a0HYvqEBzxVpTzqAM=";
    };
    x86_64-darwin = {
      platform = "macosx_10_14_x86_64";
      hash = "sha256-jykFOXOCtEtlTxN6z17m8E2g2Wpb7qdXx6w4L6w+DbY=";
    };
    aarch64-darwin = {
      platform = "macosx_11_0_arm64";
      hash = "sha256-0dBki3y9tMdjRRfYbxtl0fVTDXO8tLpx76EPISxtCy4=";
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
