{ lib }:

rec {
  version = "1.179.0";

  srcHash = "sha256-ItGRNjp0ITe50ctef6pkIdefRlUPqgo27PcqfDx5I4A=";

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
      rev = "73a6a4201803db5dbee3c29ed362805574f279cc";
      hash = "sha256-Ebfzzqwjsj9yq3Xn/LGNS4uYL2b12BQyRyuPYBpCMT0=";
    };
  };

  # fetch pre-built semgrep-core since the ocaml build is complex and relies on
  # the opam package manager at some point
  # pulling it out of the python wheel as r2c no longer release a built binary
  # on github releases
  core = {
    x86_64-linux = {
      platform = "manylinux_2_34_x86_64";
      hash = "sha256-tSnE22Pyk5GJibhM5GQPEvGx5GgNnn/KtfNVT5ET38U=";
    };
    aarch64-linux = {
      platform = "manylinux_2_34_aarch64";
      hash = "sha256-wj15xIOVQDcqzDm1mq0WfBx/PcIbrKyyfxmqLt150nE=";
    };
    aarch64-darwin = {
      platform = "macosx_11_0_arm64";
      hash = "sha256-m1cCb1h6S8eDO8orbk1neAcqedzwufLl4B09XfOcd1k=";
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
