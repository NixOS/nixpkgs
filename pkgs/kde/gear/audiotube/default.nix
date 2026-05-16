{
  mkKdeDerivation,
  fetchpatch,
  qtdeclarative,
  qtmultimedia,
  qtsvg,
  extra-cmake-modules,
  futuresql,
  kcoreaddons,
  kcrash,
  ki18n,
  kirigami-addons,
  kirigami,
  kwindowsystem,
  purpose,
  qcoro,
  python3,
}:
let
  ps = python3.pkgs;
  pythonDeps = [
    ps.yt-dlp
    ps.ytmusicapi
  ];
in
mkKdeDerivation {
  pname = "audiotube";

  patches = [
    # https://bugs.kde.org/show_bug.cgi?id=520142
    # https://github.com/NixOS/nixpkgs/issues/520685
    (fetchpatch {
      name = "pybind11-ecm-6.26.patch";
      url = "https://invent.kde.org/multimedia/audiotube/-/commit/273d9b926dfadb1b85a4a0d21c352bd5968ffa1f.patch";
      hash = "sha256-V5HghJxKYMRZP4vqIhQZeRveOcfpGXwMMEgSM3ZDbUE=";
    })
  ];

  extraNativeBuildInputs = [
    ps.pybind11
  ];

  extraBuildInputs = [
    qtdeclarative
    qtmultimedia
    qtsvg

    extra-cmake-modules
    futuresql
    kirigami
    kirigami-addons
    kcoreaddons
    ki18n
    kcrash
    kwindowsystem
    purpose
    qcoro
  ]
  ++ pythonDeps;

  qtWrapperArgs = [
    "--prefix PYTHONPATH : ${ps.makePythonPath pythonDeps}"
  ];
  meta.mainProgram = "audiotube";
}
