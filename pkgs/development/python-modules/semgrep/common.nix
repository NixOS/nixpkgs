{ lib }:

rec {
  version = "1.164.0";

  srcHash = "sha256-ced287/jH+as/1rGBOfoZ06UuQ1sf1YI4AMHbHrtnHU=";

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
      rev = "f4a74a03e8ec3dd368b96101648a3210e03fa61e";
      hash = "sha256-dy+oOB0QmZjMpTYINSPIjzhpN6d/45DaajqumKIYxC4=";
    };
  };

  # fetch pre-built semgrep-core since the ocaml build is complex and relies on
  # the opam package manager at some point
  # pulling it out of the python wheel as r2c no longer release a built binary
  # on github releases
  core = {
    x86_64-linux = {
      platform = "manylinux_2_34_x86_64";
      hash = "sha256-dFrlzhvvfJsDyStDHRdMpu54AaXioEfGSsIQTH5pUvs=";
    };
    aarch64-linux = {
      platform = "manylinux_2_34_aarch64";
      hash = "sha256-N24E9xOyRO7pXopRs+gSQM2nwHE214GfcntcoH7H7Kk=";
    };
    x86_64-darwin = {
      platform = "macosx_10_14_x86_64";
      hash = "sha256-O0kSaWou5GeoVo1UMP4J2m4RAQOQUqA+YG3PaOvjfAo=";
    };
    aarch64-darwin = {
      platform = "macosx_11_0_arm64";
      hash = "sha256-AsKxA5Wmy3NEQJ0kS6ylE33d0W86e9F494aiIkwyrcA=";
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
