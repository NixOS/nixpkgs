{ lib }:

rec {
  version = "1.143.0";

  srcHash = "sha256-macw+LuC24sT1xM1F8ovuZlBmm2lYbRifaDbSIpfmkQ=";

  # submodule dependencies
  # these are fetched so we:
  #   1. don't fetch the many submodules we don't need
  #   2. avoid fetchSubmodules since it's prone to impurities
  submodules = {
    "cli/src/semgrep/semgrep_interfaces" = {
      owner = "semgrep";
      repo = "semgrep-interfaces";
      rev = "b13a50d6524bf4fc1ae395792188d5cd9396146d";
      hash = "sha256-amsLr8kpxs6xPIh2E0/ae8KDQEjK5WiG9Hvi8ajj+Bo=";
    };
  };

  # fetch pre-built semgrep-core since the ocaml build is complex and relies on
  # the opam package manager at some point
  # pulling it out of the python wheel as r2c no longer release a built binary
  # on github releases
  core = {
    x86_64-linux = {
      platform = "musllinux_1_0_x86_64.manylinux2014_x86_64";
      hash = "sha256-M7Sn5vkk9a7xs+MbtfE+0iWHbKt8fDrDANTLkgf2kh4=";
    };
    aarch64-linux = {
      platform = "musllinux_1_0_aarch64.manylinux2014_aarch64";
      hash = "sha256-zmWdOcLloisg2SNn9RHPmTe81ktMPeNF28S8dGmSXXE=";
    };
    x86_64-darwin = {
      platform = "macosx_10_14_x86_64";
      hash = "sha256-l2rtdXZmvnHLJeFBAckVDaN+APkrbKMARUbu1oYiorU=";
    };
    aarch64-darwin = {
      platform = "macosx_11_0_arm64";
      hash = "sha256-vMJH9P2ZfHQ0FapwhSSbk/l0v+s1bDooVpBM8ILlAv4=";
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
