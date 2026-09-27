{
  lib,
  mkKdeDerivation,
  pkg-config,
  shared-mime-info,
  pcre2,

  qtsvg,
  qttools,
  qtwebengine,

  libspectre,
  poppler,
  texliveSmall, # Override with: cantor.override { texliveSmall = texliveFull; } if you want.

  withQalculate ? true,
  withR ? true,
  withPython ? true,
  withJulia ? true,
  withLua ? true,
  withMaxima ? false,
  withOctave ? false,
  withScilab ? false,
  withSage ? false,

  libqalculate,
  R, # Override with: cantor.override { R = pkgs.rWrapper.override { packages = with pkgs.rPackages; [ ggplot2 ]; }; } if you want.
  python3, # Override with: cantor.override { python3 = python3.withPackages (ps: with ps; [ matplotlib plotly bokeh ]); }
  julia, # Override with: cantor.override { julia = julia.withPackages [ "GR" "Plots" "PyPlot" "Gadfly" ]; }
  luajit,
  maxima,
  octave,
  scilab-bin,
  sage,
}:
let
  runtimeDeps =
    lib.optional withMaxima maxima
    ++ lib.optional withOctave octave
    ++ lib.optional withScilab scilab-bin
    ++ lib.optional withSage sage
    ++ lib.optional withQalculate libqalculate
    ++ lib.optional withLua luajit
    ++ lib.optional withJulia julia
    ++ lib.optional withPython python3
    ++ lib.optional withR R
    ++ [ texliveSmall ];
in
mkKdeDerivation {
  pname = "cantor";

  extraNativeBuildInputs = [
    pkg-config
    shared-mime-info
  ];

  extraBuildInputs = [
    pcre2
    qtsvg
    qttools
    qtwebengine

    libspectre
    poppler
  ]
  ++ lib.optional withQalculate libqalculate
  ++ lib.optional withLua luajit
  ++ lib.optional withJulia julia
  ++ lib.optional withPython python3
  ++ lib.optional withR R;

  extraCmakeFlags = [
    "-DCMAKE_EXE_LINKER_FLAGS=-Wl,-rpath-link,${lib.getLib pcre2}/lib"
  ]
  ++ lib.optional withR "-DR_EXECUTABLE=${lib.getExe R}"
  ++ lib.optional withJulia "-DJULIA_EXECUTABLE=${lib.getExe julia}"
  ++ lib.optional withPython "-DPython3_EXECUTABLE=${lib.getExe python3}"
  ++ lib.optional withPython "-DPython3_ROOT_DIR=${python3}"
  ++ lib.optional withPython "-DPython3_FIND_STRATEGY=LOCATION";

  preFixup = ''
    ${lib.optionalString withR ''
      patchelf --add-rpath "${lib.getLib R}/lib/R/lib" "$out/bin/cantor_rserver"
    ''}
  '';

  qtWrapperArgs = [
    "--prefix PATH : ${lib.makeBinPath runtimeDeps}"
  ];
}
