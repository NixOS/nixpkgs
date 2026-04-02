{ lib }:

rec {
  version = "1.152.0";

  srcHash = "sha256-CwF9URo3nUfkIWP277y03Bq9P6FUC4CQLjuiYwCPR6M=";

  # submodule dependencies
  # these are fetched so we:
  #   1. don't fetch the many submodules we don't need
  #   2. avoid fetchSubmodules since it's prone to impurities
  submodules = {
    "cli/src/semgrep/semgrep_interfaces" = {
      owner = "semgrep";
      repo = "semgrep-interfaces";
      rev = "76ce6450aba3422c297b35a16e38b9fd740fc860";
      hash = "sha256-hU76aICQEI7n4tWwZX2fRjgiVw811E4UDkfqQqxX8c0=";
    };
  };

  # fetch pre-built semgrep-core since the ocaml build is complex and relies on
  # the opam package manager at some point
  # pulling it out of the python wheel as r2c no longer release a built binary
  # on github releases
  core = {
    x86_64-linux = {
      platform = "musllinux_1_0_x86_64.manylinux2014_x86_64";
      hash = "sha256-XFZfCxvfCSAs2NxCCbmIU2uN0StNwEPSGaTmaHpYMPo=";
    };
    aarch64-linux = {
      platform = "musllinux_1_0_aarch64.manylinux2014_aarch64";
      hash = "sha256-XdmzHKizsxrls1Ry7pW40f4BRjA6HEayhDUXuxDHoWk=";
    };
    x86_64-darwin = {
      platform = "macosx_10_14_x86_64";
      hash = "sha256-4ZVFhsN5VyDE/VTnzfellv2dHQIT2nCTKd/54UBRPw0=";
    };
    aarch64-darwin = {
      platform = "macosx_11_0_arm64";
      hash = "sha256-rEK6kAEKdwIOcmdMhyjTn5MIXbEwLPqrZV3pg3cQINk=";
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
