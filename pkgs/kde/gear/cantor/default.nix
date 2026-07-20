{
  lib,
  mkKdeDerivation,
  pkg-config,
  shared-mime-info,

  qtsvg,
  qttools,
  qtwebengine,

  libqalculate,
  libspectre,
  luajit,
  poppler,
  texliveSmall,
  R,
  julia,
  python3,

  libxslt,
  glib,
  lapack,
  mesa,

  runtimeBackends ? {
    maxima = false;
    octave = false;
    scilab = false;
    sage = false;
    lua = false;
    python = false;
    R = false;
  },

  texliveScheme ? texliveSmall,
  pythonEnv ? python3, # Replace with python3.withPackages
  rEnv ? R, # Replace with rPackages.rWrapper

  maxima,
  octave,
  scilab-bin,
  sage,
  lua,
}:
let
  runtimeDeps =
    lib.optional runtimeBackends.maxima maxima
    ++ lib.optional runtimeBackends.octave octave
    ++ lib.optional runtimeBackends.scilab scilab-bin
    ++ lib.optional runtimeBackends.sage sage
    ++ lib.optional runtimeBackends.lua lua
    ++ lib.optional runtimeBackends.python pythonEnv
    ++ lib.optional runtimeBackends.R rEnv
    ++ [ texliveScheme ];
in
mkKdeDerivation {
  pname = "cantor";

  extraNativeBuildInputs = [
    pkg-config
    shared-mime-info
  ];

  extraBuildInputs = [
    qtsvg
    qttools
    qtwebengine

    libqalculate
    libspectre
    luajit
    poppler

    R
    julia
    python3

    libxslt
    glib
    lapack
    mesa
  ];

  extraCmakeFlags = [
    "-DR_EXECUTABLE=${R}/bin/R"
    "-DJULIA_EXECUTABLE=${julia}/bin/julia"
  ];

  qtWrapperArgs = [
    "--prefix PATH : ${lib.makeBinPath runtimeDeps}"
  ];
}
