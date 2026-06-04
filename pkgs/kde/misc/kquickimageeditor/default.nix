{
  lib,
  mkKdeDerivation,
  fetchFromGitLab,
  kirigami,
  qtdeclarative,
  opencv,
}:

mkKdeDerivation rec {
  pname = "kquickimageeditor";
  version = "0.6.1";

  # Project doesn't appear in any ../../generated/sources/*.json files,
  # although it appears in ../../generated/projects.json and
  # ../../generated/dependencies.json
  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "libraries";
    repo = "kquickimageeditor";
    rev = "v${version}";
    sha256 = "sha256-MluY8nkMtg1uLAStDZFDxyJoeDrcp3smZ4U5IG5sXMk=";
  };

  extraBuildInputs = [
    kirigami
    qtdeclarative
    (opencv.override {
      enableCuda = false; # fails to compile, disabled in case someone sets config.cudaSupport
      enabledModules = [
        "core"
        "imgproc"
      ];
      runAccuracyTests = false; # tests will fail because of missing plugins but that's okay
    })
  ];
  dontWrapQtApps = true;

  # Project doesn't exist in ../../generated/licenses.json so we write it
  # ourselves.
  meta = {
    description = "Set of QtQuick components providing basic image editing capabilities";
    homepage = "https://invent.kde.org/libraries/kquickimageeditor";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.unix;
    badPlatforms = lib.platforms.darwin;
  };
}
