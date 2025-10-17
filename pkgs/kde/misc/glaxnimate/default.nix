{
  lib,
  mkKdeDerivation,
  fetchFromGitLab,
  qttools,
  potrace,
  ffmpeg,
  libarchive,
  python3Packages,
  testers,
  glaxnimate,
  xvfb-run,
}:

mkKdeDerivation rec {
  pname = "glaxnimate";
  version = "0.5.80";

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "graphics";
    repo = "glaxnimate";
    tag = "v${version}";
    fetchSubmodules = true;
    hash = "sha256-+4vvp9nxtpKUOojgQL9T5Eyv9eMCGGwmDAex91XPwyA=";
  };

  extraBuildInputs = [
    qttools
    potrace
    ffmpeg
    libarchive
    # Has vendored `qt-color-widgets` and `pybind11`.
  ];

  qtWrapperArgs = [
    "--prefix PYTHONPATH : ${
      python3Packages.makePythonPath [
        python3Packages.pillow
        python3Packages.lottie
      ]
    }"
  ];

  passthru.tests.version = testers.testVersion {
    package = glaxnimate;
    command = "${lib.getExe xvfb-run} glaxnimate --version";
  };

  meta = {
    homepage = "https://glaxnimate.org/";
    license = with lib.licenses; [
      bsd2
      cc-by-sa-40
      cc0
      gpl2Plus
      gpl3Plus
      unicodeTOU
    ];
    maintainers = [ lib.maintainers.tobiasBora ];
    mainProgram = "glaxnimate";
  };
}
