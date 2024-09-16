{
  mkKdeDerivation,
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
}: let
  ps = python3.pkgs;
  pythonDeps = [
    ps.yt-dlp
    ps.ytmusicapi
  ];
in
  mkKdeDerivation {
    pname = "audiotube";

    extraNativeBuildInputs = [
      ps.pybind11
    ];

    extraBuildInputs =
      [
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
