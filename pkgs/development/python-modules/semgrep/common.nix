{ lib }:

rec {
  version = "1.145.0";

  srcHash = "sha256-yeTToWfCchGHGsSx/Ly3FQmj7K8iW66qItYs0MVtJvo=";

  # submodule dependencies
  # these are fetched so we:
  #   1. don't fetch the many submodules we don't need
  #   2. avoid fetchSubmodules since it's prone to impurities
  submodules = {
    "cli/src/semgrep/semgrep_interfaces" = {
      owner = "semgrep";
      repo = "semgrep-interfaces";
      rev = "e5da9678488bc24e0d5c27a4de71ad67d375cc58";
      hash = "sha256-9ilDZQmKYD2JN+CQ8VVyNyrjKYXttF+3KspRPHhuPF8=";
    };
  };

  # fetch pre-built semgrep-core since the ocaml build is complex and relies on
  # the opam package manager at some point
  # pulling it out of the python wheel as r2c no longer release a built binary
  # on github releases
  core = {
    x86_64-linux = {
      platform = "musllinux_1_0_x86_64.manylinux2014_x86_64";
      hash = "sha256-W6qWqGiuqOJcBAvTIbTCj4aMLMiAhabJ22lldu3cAR4=";
    };
    aarch64-linux = {
      platform = "musllinux_1_0_aarch64.manylinux2014_aarch64";
      hash = "sha256-WM2aq4PpYSNqB8PONJAqrYAzQNhIoK1MQvqoJri4S/Q=";
    };
    x86_64-darwin = {
      platform = "macosx_10_14_x86_64";
      hash = "sha256-cpE+GBOZnWsNKRTFzpAQCl+JaqPl0bgLvW4GFdwnMQc=";
    };
    aarch64-darwin = {
      platform = "macosx_11_0_arm64";
      hash = "sha256-FAjHtlrGLOGxE7c0/Qd+SpX6NTIh09zDbVAbxQHCDKc=";
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
    ];
  };
}
