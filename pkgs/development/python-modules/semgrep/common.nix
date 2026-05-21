{ lib }:

rec {
  version = "1.161.0";

  srcHash = "sha256-WvvEn5PUEXgwtYd72IuEljHUxcJRJh7uHzNLFqaVEbc=";

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
      rev = "8a09b2ed5838118f0ecc45305eb9d956aabcd700";
      hash = "sha256-jWv0/DADhYmBGJdMpxX8Rq2KQ2wlYIrJGGeYikcskOM=";
    };
  };

  # fetch pre-built semgrep-core since the ocaml build is complex and relies on
  # the opam package manager at some point
  # pulling it out of the python wheel as r2c no longer release a built binary
  # on github releases
  core = {
    x86_64-linux = {
      platform = "manylinux_2_35_x86_64";
      hash = "sha256-ioIlfWVDSPlCUPQQcB8RJNxwoMQzhGGsxe5xPhAbDZ0=";
    };
    aarch64-linux = {
      platform = "manylinux_2_35_aarch64";
      hash = "sha256-yDFnKdVIgt7eFNcWb0za9hdJJ7BYldEoiK46D0eRx4U=";
    };
    x86_64-darwin = {
      platform = "macosx_10_14_x86_64";
      hash = "sha256-NFBo32ZfO0h0KunOaWefWRnyuu1XkYku5RTxOpCfWWQ=";
    };
    aarch64-darwin = {
      platform = "macosx_11_0_arm64";
      hash = "sha256-H51DqX94yMqbwvDrlIa3D64hBtvYAvelK7HLnVj588g=";
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
