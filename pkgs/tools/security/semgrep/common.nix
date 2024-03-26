{ lib }:

rec {
  version = "1.63.0";

  srcHash = "sha256-VMB+slexCXxv9z6kOxbYQrnet6sb4ZKTATXWkLix9u4=";

  # submodule dependencies
  # these are fetched so we:
  #   1. don't fetch the many submodules we don't need
  #   2. avoid fetchSubmodules since it's prone to impurities
  submodules = {
    "cli/src/semgrep/semgrep_interfaces" = {
      owner = "semgrep";
      repo = "semgrep-interfaces";
      rev = "8751faab89f23f7af3a92f5d4d4e6451ccaa205a";
      hash = "sha256-0Si4wUymwA2k/u953GifYgHKi6gvu3FiaDHm1Kj30sA=";
    };
  };

  # fetch pre-built semgrep-core since the ocaml build is complex and relies on
  # the opam package manager at some point
  # pulling it out of the python wheel as r2c no longer release a built binary
  # on github releases
  core = {
    x86_64-linux = {
      platform = "any";
      hash = "sha256-KBiYd1zWDxs5T2AGR49o/X2J6espuqi7ykCh3Zsg8i4=";
    };
    x86_64-darwin = {
      platform = "macosx_10_14_x86_64";
      hash = "sha256-EfVpKdRE5qvEVMGu8QUM183YPNDjgxQlca3nUb3m1tw=";
    };
    aarch64-darwin = {
      platform = "macosx_11_0_arm64";
      hash = "sha256-ksqkVdE7aIbeETSxLpDXef6Hmv7G5LxQ0+v+/G9OpKk=";
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
