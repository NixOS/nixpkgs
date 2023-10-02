{ lib }:

rec {
  version = "1.37.0";

  srcHash = "sha256-oFJ43dq3DAhux0UEFDKFZnxruoRdOfCndKY6XgG3d5I=";

  # submodule dependencies
  # these are fetched so we:
  #   1. don't fetch the many submodules we don't need
  #   2. avoid fetchSubmodules since it's prone to impurities
  submodules = {
    "cli/src/semgrep/semgrep_interfaces" = {
      owner = "returntocorp";
      repo = "semgrep-interfaces";
      rev = "331603197022625f50a64dd5e3029a96a5f03ada";
      hash = "sha256-UAcWbTSCIdBGvgGSbdQ+miFOEuBvQ6m42MkU3VeErKY=";
    };
  };

  # fetch pre-built semgrep-core since the ocaml build is complex and relies on
  # the opam package manager at some point
  # pulling it out of the python wheel as r2c no longer release a built binary
  # on github releases
  core = {
    x86_64-linux = {
      platform = "any";
      hash = "sha256-Sj/6tzZMyRQAJL09X/3zgvdGTIhNibqO8usKsus9Xss=";
    };
    x86_64-darwin = {
      platform = "macosx_10_14_x86_64";
      hash = "sha256-hC04VknZG6aYYNX7lqvkcOoVslewNqlYax+o1nV2TcM=";
    };
    aarch64-darwin = {
      platform = "macosx_11_0_arm64";
      hash = "sha256-0F+ndM4+0dnxf9acwWvGdIy9iYWSqixS9IzOxa95/yM=";
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
